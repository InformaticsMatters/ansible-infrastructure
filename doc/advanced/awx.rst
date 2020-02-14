***
AWX
***

.. _AWX Rendering:

Inventory Rendering
===================

Installation of AWX is simple in itself but we have further automated it so
that installation of the infrastructure is a *one step* process.

In order to do this the AWX repository is cloned to the control machine as
part of the infrastructure installation and the infrastructure variables are
then used to *render* the inventory file in the clone of the AWX repository
before invoking ``ansible-playbook`` on it.

The rendering logic that manipulates the AWX inventory is something you need
to provide.

The logic is expected to reside in the ``infrastructure/tasks``
directory of the ``infrastructure`` Role. The logic is just Ansible code.
The filename of the rendering logic must follow the format
``render-awx-<ax_version>-<ax_platform>.yaml``. For AWX 9.2.0 on Kubernetes
this would be ``render-awx-9.2.0-kubernetes.yaml``.

Check the AWX `Installation Guide`_ for details of how to adjust its
inventory file.

You might not need to do anything new in your rendering logic except
copy an earlier file. For example, the rendering for version 9.2.0 is
the same as that used for 9.1.1.

Upgrading the server
====================

To upgrade the AWX server you simply need to set the Role variable ``ax_version``
and re-run the playbook. The role should detect the version change and then
clone the provided version, render the inventory and install it.

Remember that each version needs render logic (refer to the `AWX Rendering`_
section on how to do this).

.. _installation guide: https://github.com/ansible/awx/blob/devel/INSTALL.md
