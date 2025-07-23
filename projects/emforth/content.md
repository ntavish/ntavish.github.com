<zero-md> <script type="text/markdown">
# emforth: a forth implemented in C

**Dated**: 2025/07/22

**Source**: https://github.com/ntavish/emforth

I've been fascinated by forth for a long time, and this is my attempt trying to bootstrap it in my own
mind. For some people, it may be a weekend project, but I have taken a shamefully long time, giving up
or forgetting about it for months, but finally I consider the 'core' to be mostly finished. Finally this
forth will run on an MCU, hopefully connected to a display and a keyboard to let you run forth code on.

Forth is the first of a class of programming languages known as concatenative programming languages. If
you ask whether it is interpreted or compiled - the answer is yes. You need a very small amount of
functionality implemented in the core of the imeplementation, and the rest of your programming environment
can be bootstrapped and be written in forth code itself. I do not have much experience implementing
programming languagues or writing DSLs, but forth is coneptually 'simple' and the core implementation
small enough that you can implement it as a small project. (I say small, but that's for some other people,
it took me quite long due to scrapping everything a couple of times at least after discovering some
fundamental problems)

Note: the goals of the repo have since changed to - just work, on anything, it is no longer aiming to
be sand-boxed, I have since realized that I need a quite different approach to that. Currently this
seems to work on linux/amd64 and in the browser via emscriptem, other targets should work as well, just
not tested.

# Demo

<iframe 
    src="console/index.html" 
    width="100%" 
    height="600px" 
    style="border: 1px solid #333; border-radius: 4px;">
</iframe>

Type `words` for list of available words, define new words like `: square dup * ;`, and test it with
`5 square .`. You can see the definition of the word you just compiled with `see square`.

There are many features not yet implemented in this, and many things not supported (although some features
are going to be quite easy to implement in forth itself now that most of the required primitive words are
available).

However, to give you an idea of how a forth bootstraps: there is no control flow (if/else, loops etc)
implemented within the built-in words, however, the only required words which can implement these are
branch and 0branch.

If/then/else can now be implemented as forth words itself. See the file [test.forth](https://raw.githubusercontent.com/ntavish/emforth/refs/heads/main/test.forth)
for how these can be implemented.

# Documentation:

<zero-md src='https://raw.githubusercontent.com/ntavish/emforth/main/README.md'></zero-md>

</script></zero-md>

