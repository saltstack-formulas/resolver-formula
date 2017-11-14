========
resolver
========
SaltStack formula to manage /etc/resolv.conf with or without `resolvconf`.

.. Note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``resolver``
------------

Manage entries inside `/etc/resolv.conf`.

Configuration
=============

The `resolvconf` package is enabled by default for Debian based distributions
and you can manage `/etc/resolv.conf` directly without remove `resolvconf` package.


.. code:: yaml

    resolver:
      resolvconf:
        enabled: False
      nameservers:
        - 8.8.8.8
        - 8.8.4.4
      searchpaths:
        - internal
      options:
        - rotate
        - timeout:1
        - attempts:5

.. vim: fenc=utf-8 spell spl=en cc=100 tw=99 fo=want sts=4 sw=4 et
