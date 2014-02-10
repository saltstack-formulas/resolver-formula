#####################################
##### Salt Formula For Resolver #####
#####################################

# Resolver Configuration
resolver:
  file.managed:
    - name: /etc/resolv.conf
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - source: salt://resolver/files/resolv.conf
