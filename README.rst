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

3. Add a pillar with your configuration items

.. code-block:: yaml

  resolver:
    searchpaths: example.com
    nameservers:
      - 8.8.8.8
      - 4.4.4.4
