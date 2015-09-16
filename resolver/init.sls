#####################################
##### Salt Formula For Resolver #####
#####################################

{% set resolvconf = 0 == salt['cmd.retcode']('test -f /sbin/resolvconf') %}

# Resolver Configuration
resolv-file:
  file.managed:
    {% if resolvconf %}
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

{% if resolvconf %}
resolv-update:
  cmd.run:
    - name: resolvconf -u
    - onchanges:
      - file: resolv-file
{% endif %}
