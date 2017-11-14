{% from slspath + "/map.jinja" import resolver with context %}

{{ sls }}~pkg:
  {% if resolver.resolvconf.remove %}
  pkg.purged:
  {% else %}
  pkg.installed:
  {% endif %}
    - name: resolvconf
    - require_in:
      - file: {{ sls }}~update-resolv.conf-file

{{ sls }}~update-resolv.conf-file:
  file.managed:
    {% if resolver.resolvconf.enabled and not resolver.resolvconf.remove %}
    - name: /etc/resolvconf/resolv.conf.d/base
    {% else %}
    - name: /etc/resolv.conf
    - follow_symlinks: False
    {% endif %}
    - user: root
    - group: root
    - mode: '0644'
    - source: salt://{{ slspath }}/templates/resolv.conf.jinja
    - template: jinja
    - defaults:
        nameservers: {{ resolver.nameservers }}
        searchpaths: {{ resolver.searchpaths }}
        options: {{ resolver.options }}
        domain: {{ resolver.domain }}

{% if resolver.resolvconf.enabled and not resolver.resolvconf.remove %}
{{ sls }}~update-resolvconf:
  file.symlink:
    - name: /etc/resolv.conf
    - target: {{ resolver.resolvconf.file }}
    - force: True
  cmd.run:
    - name: resolvconf -u
    - onchanges:
      - file: {{ sls }}~update-resolv.conf-file
{% endif %}
