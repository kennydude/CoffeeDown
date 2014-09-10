{#
CoffeeDoc Markdown Template

This file looks a bit of mess, but it's simply a template.

If you're viewing this on Github.com, then it probably looks even worse,
just use the raw view.

Uses SWIG/Django syntax
---

Macro for defining parameters.

Most parameters work the same, so DRY
#}{% macro params(params) %}
{% for param in params %}* `{{ param.name }}` ({{param.type}}) {{ param.description | indentNL | raw }}
{% endfor %}
{% endmacro %}{#
Main Contents
#}{% for endpoint in endpoints %}## {{ endpoint.method | raw }} {{ endpoint.path | raw }}

{{ endpoint.description | raw }}
{% if endpoint.auth %}
**Authentication:** {{ endpoint.auth.type | raw }}{% if endpoint.auth.scope %} requiring scope {{ endpoint.auth.scope.join(", ") | raw }}{% endif %}
{% endif %}

{% if endpoint.params.length > 0 %}
### URL Parameters

{{ params(endpoint.params) }}
{% endif %}

{% if endpoint.query_string.length > 0 %}
### Query String Parameters

{{ params(endpoint.query_string) }}
{% endif %}

{% if endpoint.body.length > 0 %}
### Body

{{ params(endpoint.body) }}
{% endif %}

{% endfor %}
