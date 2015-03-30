#####################################
##### Salt Formula For Resolver #####
#####################################

{% from "resolver/map.jinja" import resolver with context %}

# Resolver Configuration
resolver:
  pkg.removed:
    - name: {{resolver.package}}

/etc/resolv.conf:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - source: salt://resolver/files/resolv.conf
    - template: jinja
    - defaults:
        nameservers: {{ salt['pillar.get']('resolver:nameservers', ['8.8.8.8','8.8.4.4']) }}
        searchpaths: {{ salt['pillar.get']('resolver:searchpaths', salt['grains.get']('domain')) }}
        options: {{ salt['pillar.get']('resolver:options', []) }}
    - require:
        - pkg: resolver
