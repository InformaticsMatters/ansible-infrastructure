***************************
Creating the Infrastructure
***************************

The infrastructure deployment is *fine-tuned* with Ansible parameter files.
Some are pre-built (with their content encrypted using `Ansible Vault`_)
but you can also create your won.

When deploying it's useful to be able to observe the Kubernetes cluster,
either with the ``kubectl`` command-line or a visual dashboard like `Lens`_.

..  note::
    A typical AWS deployment, consisting of EFS provisioner, Database, AWX
    and keycloak, is likely to take around 15 minutes to complete.
    After this you should have AWX and Keycloak resolvable at the hostnames
    you provided as parameters. Now configure AWX and you're off...

..  warning::
    **DO NOT** delete the cluster before you uninstall all the resident
    applications. If you delete the cluster without removing services like EFS
    you may end up with VPCs and other services that cannot be deleted because
    infrastructure components still exist. Tearing a cluster down requires careful
    thought.

Cluster Context (for AWX)
=========================

To install AWX you will need the context name of the cluster,
located in your ``kubeconfig`` file::

    contexts:
    - name: "im-demo"
      context:
        user: "im-demo"
        cluster: "im-demo"

Creating (using your own parameters)
====================================

If you're creating a new cluster you'll need to define a number of key
parameters (variables). Start with a copy of the template file
``parameters.template`` and replace the variable values in it with ones
suitable for your cluster::

    $ cp parameters.template parameters-me

At the very least you sill need to provide values
for all the ``SetMe`` examples (and the others if required).

..  note::
    The template contains a small set of essential variables. You can inspect
    ``defaults/main.yaml`` and ``vars/main.yaml`` if you want to see every
    parameter that's available to you.

Once edited, to deploy the infrastructure, you then name the parameter file in
the Ansible playbook command::

    $ INFRA_NAME=me
    $ CLUSTER_CONTEXT=demo
    $ ansible-playbook \
        -e @parameters-$INFRA_NAME \
        -e ax_kubernetes_context=$CLUSTER_CONTEXT \
        site.yaml

..  note::
    Remember to preserve you parameter file somewhere.

Creating (using pre-built parameters)
=====================================

All pre-built parameter files (basically Ansible variables) are encrypted as
``.vault`` files in the root of this repository using `Ansible Vault`_.
For example, you will find a set of parameters for our *im-main* site in the
file ``parameters-im-main-eks.vault``.

If you need to edit a pre-built parameter file it should be viewed and edited
*in situ* using ``ansible-vault``::

    $ INFRA_NAME=im-main-eks
    $ ansible-vault edit parameters-$INFRA_NAME.vault

Using an appropriate parameter file, create (deploy) the **im-main-eks**
infrastructure using the root-level ansible playbook ``site.yaml``.

It's the same playbook regardless of cluster - only the parameter file needs
so change::

    $ INFRA_NAME=im-main-eks
    $ CLUSTER_CONTEXT=demo
    $ ansible-playbook \
        -e @parameters-$INFRA_NAME.vault \
        -e ax_kubernetes_context=$CLUSTER_CONTEXT \
        site.yaml \
        --ask-vault-pass

.. _Ansible Vault: https://docs.ansible.com/ansible/latest/user_guide/vault.html
.. _Lens: https://github.com/lensapp/lens
