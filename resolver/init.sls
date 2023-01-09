#####################################
##### Salt Formula For Resolver #####
#####################################
{% from slspath + "/map.jinja" import resolver with context %}

{% if salt['pillar.get']('resolver:use_resolvconf', True) %}
  {% set is_resolvconf_enabled = grains['os_family'] in ('Debian') %}
{% else %}
  {% set is_resolvconf_enabled = False %}
{% endif %}

resolvconf-manage:
  {% if is_resolvconf_enabled %}
  pkg.installed:
  {% else %}
  pkg.purged:
  {% endif %}
    - name: resolvconf
    - require_in:
      - file: resolv-file

{%- if not is_resolvconf_enabled %}
remove-symlink:
  file.absent:
    - name: /etc/resolv.conf
    - require:
      - resolvconf-manage
    - require_in:
        - resolv-file
    - onchanges:
      - resolvconf-manage
{%- endif %}

# Resolver Configuration
resolv-file:
  file.managed:
    {% if is_resolvconf_enabled %}
    - name: /etc/resolvconf/resolv.conf.d/base
    {% else %}
    - name: /etc/resolv.conf
    {% endif %}
    - user: {{ resolver.user }}
    - group: {{ resolver.group }}
    - mode: '0644'
    - source: salt://resolver/files/resolv.conf
    - template: jinja
    - defaults:
        nameservers: {{ salt['pillar.get']('resolver:nameservers', ['8.8.8.8','8.8.4.4']) }}
        searchpaths: {{ salt['pillar.get']('resolver:searchpaths', [salt['grains.get']('domain'),]) }}
        options: {{ salt['pillar.get']('resolver:options', []) }}
        domain: {{ salt['pillar.get']('resolver:domain') }}

{% if is_resolvconf_enabled %}
resolv-update:
  file.symlink:
    - name: /etc/resolv.conf
    - target: {{ resolver.conf_path }}
    - force: True

  cmd.run:
    - name: resolvconf -u
    - onchanges:
      - file: resolv-file
{% endif %}
