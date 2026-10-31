#!/usr/bin/env python3
"""Local preview server for ntavish.in -- no build step, nothing to install.

    python3 serve.py                          serve the site on http://localhost:8000
    python3 serve.py 8080                     ...on another port
    python3 serve.py --render blog/feed.xml   print one rendered file and exit

Files are served as-is, with caching disabled so edits show up on reload.

Files that start with Jekyll front matter (a line "---" ... "---", e.g. blog/feed.xml)
are rendered the way GitHub Pages' Jekyll renders them. Only the small subset of
Liquid that those files use is supported; anything else stops with an error rather
than producing output that differs from the live site.

Supported Liquid:
  {{ expr | filter: arg }}    {% assign x = expr | filter %}    {% capture x %}..{% endcapture %}
  {% for x in arr offset:N %}..{% endfor %}    {% if a == b %}..{% else %}..{% endif %}
  {% unless a contains b %}..{% endunless %}    (operators: == != contains)
  {% comment %}..{% endcomment %}    {% include_relative path %} (path may contain {{ var }})
  whitespace control ({%- -%} {{- -}}), variables, a.b, a[N], "strings", 'strings', integers
  filters: split first last remove_first replace strip newline_to_br append xml_escape
           date_to_xmlschema (site.time only)
"""
import datetime
import http.server
import os
import re
import sys

ROOT = os.path.dirname(os.path.abspath(__file__))


class LiquidError(Exception):
    pass


# --------------------------------------------------------------------- tokenizer

TOKEN_RE = re.compile(r"(\{\{-?.*?-?\}\}|\{%-?.*?-?%\})", re.S)


def tokenize(src):
    """Split into ('text'|'out'|'tag', content), applying whitespace control."""
    parts = TOKEN_RE.split(src)
    toks = []
    for i, p in enumerate(parts):
        if i % 2 == 0:
            toks.append(["text", p])
            continue
        kind = "out" if p.startswith("{{") else "tag"
        inner = p[2:-2]
        if inner.startswith("-"):
            inner = inner[1:]
            toks[-1][1] = toks[-1][1].rstrip()      # trim text before
        if inner.endswith("-"):
            inner = inner[:-1]
            if i + 1 < len(parts):
                parts[i + 1] = parts[i + 1].lstrip()  # trim text after
        toks.append([kind, inner.strip()])
    return toks


# --------------------------------------------------------------------- parser

def parse(toks, pos=0, until=()):
    """Return (nodes, pos, closing_tag_name)."""
    nodes = []
    while pos < len(toks):
        kind, val = toks[pos]
        pos += 1
        if kind == "text":
            if val:
                nodes.append(("text", val))
        elif kind == "out":
            nodes.append(("out", val))
        else:
            name, _, rest = val.partition(" ")
            rest = rest.strip()
            if name in until:
                return nodes, pos, name
            if name == "comment":
                while pos < len(toks) and not (toks[pos][0] == "tag" and toks[pos][1] == "endcomment"):
                    pos += 1
                pos += 1
            elif name == "assign":
                var, eq, expr = rest.partition("=")
                if not eq:
                    raise LiquidError("bad assign: " + val)
                nodes.append(("assign", var.strip(), expr.strip()))
            elif name == "capture":
                body, pos, _ = parse(toks, pos, ("endcapture",))
                nodes.append(("capture", rest, body))
            elif name == "for":
                m = re.fullmatch(r"(\w+) in ([\w.\[\]]+)(?:\s+offset:\s*(\d+))?", rest)
                if not m:
                    raise LiquidError("unsupported for: " + val)
                body, pos, _ = parse(toks, pos, ("endfor",))
                nodes.append(("for", m.group(1), m.group(2), int(m.group(3) or 0), body))
            elif name in ("if", "unless"):
                endtag = "end" + name
                yes, pos, end = parse(toks, pos, ("else", endtag))
                no = []
                if end == "else":
                    no, pos, _ = parse(toks, pos, (endtag,))
                if name == "unless":
                    yes, no = no, yes
                nodes.append(("if", rest, yes, no))
            elif name == "include_relative":
                nodes.append(("include", rest))
            else:
                raise LiquidError("unsupported tag: {% " + val + " %}")
    if until:
        raise LiquidError("missing {% " + until[-1] + " %}")
    return nodes, pos, None


# --------------------------------------------------------------------- evaluation

def ruby_split(s, sep):
    out = s.split(sep)
    while out and out[-1] == "":              # Ruby drops trailing empty fields
        out.pop()
    return out


def xml_escape(s):                            # Ruby CGI.escapeHTML
    return (s.replace("&", "&amp;").replace("'", "&#39;").replace('"', "&quot;")
             .replace("<", "&lt;").replace(">", "&gt;"))


def to_s(v):
    return "" if v is None else str(v)


def apply_filter(name, val, args):
    if name == "split":
        return ruby_split(to_s(val), to_s(args[0]))
    if name == "first":
        return val[0] if val else None
    if name == "last":
        return val[-1] if val else None
    if name == "remove_first":
        return to_s(val).replace(to_s(args[0]), "", 1)
    if name == "replace":
        return to_s(val).replace(to_s(args[0]), to_s(args[1]))
    if name == "strip":
        return to_s(val).strip()
    if name == "newline_to_br":
        return re.sub(r"\r?\n", "<br />\n", to_s(val))
    if name == "append":
        return to_s(val) + to_s(args[0])
    if name == "xml_escape":
        return None if val is None else xml_escape(to_s(val))
    if name == "date_to_xmlschema":
        if not isinstance(val, datetime.datetime):
            raise LiquidError("date_to_xmlschema only supported on site.time")
        return val.isoformat(timespec="seconds")
    raise LiquidError("unsupported filter: " + name)


ARG_RE = re.compile(r"""\s*("[^"]*"|'[^']*'|[^,]+)\s*(?:,|$)""")


def literal_or_var(s, ctx):
    s = s.strip()
    if len(s) >= 2 and s[0] == s[-1] and s[0] in "\"'":
        return s[1:-1]
    if re.fullmatch(r"-?\d+", s):
        return int(s)
    val = None
    for i, part in enumerate(re.findall(r"[\w]+|\[\d+\]", s)):
        if i == 0:
            if part not in ctx:
                raise LiquidError("undefined variable: " + s)
            val = ctx[part]
        elif part.startswith("["):
            idx = int(part[1:-1])
            val = val[idx] if isinstance(val, list) and -len(val) <= idx < len(val) else None
        elif part == "size":
            val = len(val) if val is not None else 0
        elif isinstance(val, dict):
            val = val.get(part)
        else:
            raise LiquidError("cannot look up ." + part + " in: " + s)
    return val


def split_pipes(expr):
    """Split on | outside quotes."""
    parts, cur, q = [], "", None
    for ch in expr:
        if q:
            cur += ch
            if ch == q:
                q = None
        elif ch in "\"'":
            q = ch
            cur += ch
        elif ch == "|":
            parts.append(cur)
            cur = ""
        else:
            cur += ch
    parts.append(cur)
    return parts


def evaluate(expr, ctx):
    head, *filters = split_pipes(expr)
    val = literal_or_var(head, ctx)
    for f in filters:
        name, _, argstr = f.strip().partition(":")
        args = [literal_or_var(a, ctx) for a in ARG_RE.findall(argstr)] if argstr.strip() else []
        val = apply_filter(name.strip(), val, args)
    return val


def condition(expr, ctx):
    m = re.fullmatch(r"(.+?)\s+(==|!=|contains)\s+(.+)", expr)
    if not m:
        raise LiquidError("unsupported if/unless: " + expr)
    a, b = literal_or_var(m.group(1), ctx), literal_or_var(m.group(3), ctx)
    if m.group(2) == "contains":
        if isinstance(a, list):
            return b in a
        return a is not None and to_s(b) in to_s(a)
    a, b = ("" if a is None else a), ("" if b is None else b)
    return (a == b) if m.group(2) == "==" else (a != b)


def render_nodes(nodes, ctx, basedir):
    out = []
    for n in nodes:
        t = n[0]
        if t == "text":
            out.append(n[1])
        elif t == "out":
            out.append(to_s(evaluate(n[1], ctx)))
        elif t == "assign":
            ctx[n[1]] = evaluate(n[2], ctx)
        elif t == "capture":
            ctx[n[1]] = render_nodes(n[2], ctx, basedir)
        elif t == "for":
            items = literal_or_var(n[2], ctx) or []
            for item in items[n[3]:]:
                ctx[n[1]] = item
                out.append(render_nodes(n[4], ctx, basedir))
        elif t == "if":
            out.append(render_nodes(n[2] if condition(n[1], ctx) else n[3], ctx, basedir))
        elif t == "include":
            rel = re.sub(r"\{\{\s*(.+?)\s*\}\}", lambda m: to_s(evaluate(m.group(1), ctx)), n[1]).strip()
            if ".." in rel or rel.startswith("/"):
                raise LiquidError("include_relative cannot go up a directory: " + rel)
            path = os.path.join(basedir, rel)
            if not os.path.isfile(path):
                raise LiquidError("include_relative file not found: " + rel)
            with open(path, encoding="utf-8") as f:
                toks = tokenize(f.read())
            out.append(render_nodes(parse(toks)[0], ctx, os.path.dirname(path)))
    return "".join(out)


FRONT_MATTER = re.compile(r"\A---[ \t]*\r?\n(.*?)^---[ \t]*\r?\n", re.S | re.M)


def has_front_matter(path):
    with open(path, "rb") as f:
        return f.read(4) in (b"---\n", b"---\r")


def render_file(path):
    with open(path, encoding="utf-8") as f:
        src = f.read()
    m = FRONT_MATTER.match(src)
    if not m:
        raise LiquidError("no front matter: " + path)
    if m.group(1).strip():
        raise LiquidError("front matter variables are not supported: " + path)
    if path.endswith((".md", ".markdown", ".html")):
        raise LiquidError("only non-markdown, non-html templates are supported: " + path)
    ctx = {"site": {"time": datetime.datetime.now().astimezone()}}
    return render_nodes(parse(tokenize(src[m.end():]))[0], ctx, os.path.dirname(path))


# --------------------------------------------------------------------- server

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *a, **kw):
        super().__init__(*a, directory=ROOT, **kw)

    def end_headers(self):
        self.send_header("Cache-Control", "no-store")
        super().end_headers()

    def send_head(self):
        path = self.translate_path(self.path)
        if os.path.isfile(path) and has_front_matter(path):
            try:
                body = render_file(path).encode("utf-8")
            except LiquidError as e:
                self.send_error(500, "Template error: %s" % e)
                return None
            self.send_response(200)
            self.send_header("Content-Type", self.guess_type(path))
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            import io
            return io.BytesIO(body)
        return super().send_head()


def main():
    args = sys.argv[1:]
    if args[:1] == ["--render"]:
        if len(args) != 2:
            sys.exit("usage: serve.py --render path/to/file")
        try:
            sys.stdout.write(render_file(os.path.join(ROOT, args[1])))
        except LiquidError as e:
            sys.exit("Template error: %s" % e)
        return
    port = int(args[0]) if args else 8000
    print("Serving %s on http://localhost:%d (no caching; Ctrl+C to stop)" % (ROOT, port))
    http.server.ThreadingHTTPServer(("", port), Handler).serve_forever()


if __name__ == "__main__":
    main()
