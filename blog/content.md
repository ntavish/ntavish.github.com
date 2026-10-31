<script>
  // Section landing page: open the first (latest) entry from this section's menu.md,
  // skipping non-page links such as the RSS feed.
  fetch('menu.md')
    .then(function (r) { return r.text(); })
    .then(function (t) {
      var links = new DOMParser().parseFromString(t, 'text/html').querySelectorAll('a[href]');
      for (var i = 0; i < links.length; i++) {
        var href = links[i].getAttribute('href');
        if (!/\.xml$/.test(href)) { location.replace(href); return; }
      }
    });
</script>
