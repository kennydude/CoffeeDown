{% macro params(params) %}
{% for param in params %}* `{{ param.name }}` ({{param.type}}) {{ param.description | indentNL }}
{% endfor %}
{% endmacro %}
{% for endpoint in endpoints %}## {{ endpoint.method }} {{ endpoint.path }}

{{ endpoint.description }}
{% if endpoint.auth %}
**Authentication:** {{ endpoint.auth.type }}{% if endpoint.auth.scope %}requiring scope {{ endpoint.auth.scope.join(", ") }}{% endif %}
{% endif %}

{% if endpoint.params.length > 0 %}
### URL Parameters

{{ params(endpoint.query_string) }}
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
