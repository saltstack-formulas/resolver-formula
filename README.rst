resolver
========

This SaltStack formula allows to update /etc/resolv.conf on minions.
How to use it:

1. Add git fileserver backend to your master config:

.. code-block:: yaml

  fileserver_backend:
    - roots
    - git

2. Add formula git URL to gitfs_remotes in your master config:

.. code-block:: yaml

  gitfs_remotes:
    - git+ssh://git@github.com/saltstack-formulas/resolver-formula.git

3. Extend formula by your settings:

.. code-block:: yaml

  include:
    - resolver
  extend:
    /etc/resolv.conf:
      file.managed:
        - context:
            searchpath: your.domain.name
            nameservers:
              - 192.168.1.1
