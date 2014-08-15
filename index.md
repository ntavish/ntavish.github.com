---
layout: page
title: Home
tagline:
---
{% for post in site.posts limit:2 %}
<div class="post">
<h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
<div class="body">
{{ post.content }}
</div>
<div class="meta">
Posted on <a href="{{ post.url }}">{{ post.date | date_to_string }}</a>
</div>
</div>
<hr>
{% endfor %}