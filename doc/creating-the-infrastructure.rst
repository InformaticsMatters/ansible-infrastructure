***************************
Creating the Infrastructure
***************************

Parameters (vault files)
------------------------

Assuming you've followed the :doc:`getting-started` section, creating the
cluster infrastructure relies on using or creating a set of *parameters* that
define the infrastructure for a given cluster.

*   All official parameter files (basically Ansible variables) are encrypted as
    ``.vault`` files in the root of this repository using `Ansible Vault`_.
*   You will find a set of parameters for our *im-main* site in the file
    ``parameters-im-main.vault``.

Editing parameter files
-----------------------

Parameter files can be (and should be) viewed and edited *in situ*
using ``ansible-vault``::

    $ INFRA_NAME=im-main-eks
    $ ansible-vault edit parameters-$INFRA_NAME.vault

Creating
--------

Using an appropriate parameter file, create (deploy) the **im-main**
infrastructure using the root-level ansible playbook ``site.yaml``.
It's the same playbook regardless of cluster - only the parameter file needs
so change::

    $ INFRA_NAME=im-main
    $ ansible-playbook \
        -e @parameters-$INFRA_NAME.vault \
        site.yaml \
        --ask-vault-pass

>   A typical AWS deployment, consisting of EFS provisioner, Database, AWX
    and keycloak, is likely to take around 15 minutes to complete.
    After this you should have AWX and Keycloak resolvable at the hostnames
    you provided as parameters. Now configure AWX and you're off...

Caution, **DO NOT** delete the cluster before you uninstall all the resident
applications. If you delete the cluster without removing services like EFS
you may end up with VPCs and other services that cannot be deleted because
infrastructure components still exist. Tearing a cluster down requires careful
thought.

.. _Ansible Vault: https://docs.ansible.com/ansible/latest/user_guide/vault.html
