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
    ``site-im-main-parameters.vault``.

Editing parameter files
-----------------------

Parameter files can be (and should be) viewed and edited *in situ*
using ``ansible-vault``::

    $ INFRA_NAME=im-main
    $ ansible-vault edit site-$INFRA_NAME-parameters.vault

Creating
--------

Using an appropriate parameter file, create (deploy) the **im-main**
infrastructure using the root-level ansible playbook ``site.yaml``.
It's the same playbook regardless of cluster::

    $ INFRA_NAME=im-main
    $ ansible-playbook \
        -e @site-$INFRA_PARAMS-parameters.vault \
        site.yaml \
        --ask-vault-pass

Caution, **DO NOT** delete the cluster before uninstall akk the resident
applications. If you delete the cluster without removing services like EFS
you may end up with VPCs and other services that cannot be deleted because
infrastructure components still exist.

.. _Ansible Vault: https://docs.ansible.com/ansible/latest/user_guide/vault.html
