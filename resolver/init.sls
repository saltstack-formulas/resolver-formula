#####################################
##### Salt Formula For Resolver #####
#####################################

{% set is_resolvconf_enabled = grains['os'] == 'Ubuntu' and salt['pkg.version']('resolvconf') %}

# Resolver Configuration
resolv-file:
  file.managed:
    {% if is_resolvconf_enabled %}
    - name: /etc/resolvconf/resolv.conf.d/base
    {% else %}
    - name: /etc/resolv.conf
    {% endif %}
    - user: root
    - group: root
    - mode: '0644'
    - source: salt://resolver/files/resolv.conf
    - template: jinja
    - defaults:
        nameservers: {{ salt['pillar.get']('resolver:nameservers', ['8.8.8.8','8.8.4.4']) }}
        searchpaths: {{ salt['pillar.get']('resolver:searchpaths', [salt['grains.get']('domain'),]) }}
        options: {{ salt['pillar.get']('resolver:options', []) }}

{% if is_resolvconf_enabled %}
resolv-update:
  cmd.run:
    - name: resolvconf -u
    - onchanges:
      - file: resolv-file
{% endif %}
