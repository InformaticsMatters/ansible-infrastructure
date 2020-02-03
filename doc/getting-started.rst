***************
Getting Started
***************

Prerequisites
=============

Before starting a basic understanding or experience with the following will
be beneficial: -

*   `Kubernetes`_
*   `Ansible`_ playbooks and roles
*   `Ansible Galaxy`_
*   `Ansible Vault`_

Working environment
===================

Ideally you'll start from a Python 3.8 virtual environment and then install
the required modules, roles and collections::

    $ conda activate ansible-infrastructure
    $ pip install -r requirements.txt
    $ ansible-galaxy install -r role-requirements.yaml --force-with-deps
    $ ansible-galaxy collection install -r collection-requirements.yaml --force-with-deps

Cluster (Kubernetes) pre-requisites
===================================

Your Kubernetes cluster will need: -

1.  A **StorageClass** for the infrastructure database (postgres).
    You will define the name of the cluster's storage class
    in parameters you pass to the playbook
    (see the **Creating** section below).
1.  To help organise Pod deployment you should have nodes
    with the label ``purpose=application``. This is not mandatory,
    but recommended.
1.  Domain names should be routed to your cluster.
    You will set the actual names using parameters but you should have
    resolvable domain names for infrastructure components that will be deployed
    (e.g. domains for the **AWX** and **Keycloak** services).

Cluster credentials
===================

You should be in possession of a Kubernetes configuration file. Plays run
from within AWX benefit from the automatic injection of Kubernetes variables.
Once installed our AWX will inject the following environment variables: -

-   ``K8S_AUTH_HOST``
-   ``K8S_AUTH_API_KEY``
-   ``K8S_AUTH_VERIFY_SSL``

As we're deploying the infrastructure components (from outside AWX)
we need to provide values for these. The ``HOST`` is the **cluster -> server**
value of your control plane from the config file and ``API_KEY`` is the
**user-> token** value::

    $ export K8S_AUTH_HOST=https://1.2.3.4:6443
    $ export K8S_AUTH_API_KEY=kubeconfig-user-abc:00000000
    $ export K8S_AUTH_VERIFY_SSL=no

>   If you intend to use **kubectl** you will need to set ``KUBECONFIG`` variable
    to point to a local copy of the cluster config file. You can safely place
    the config in the root of a clone of this repository as the file
    ``kubeconfig`` as this is part fo the project ignore set.

    $ export KUBECONFIG=./kubeconfig

You will also need to provide standard AWS credentials for the cluster you're
configuring via the environment for some of the Roles to properly function::

    $ export AWS_ACCESS_KEY_ID=xxxxxxxxxxxx
    $ export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxx


.. _Ansible:https://pypi.org/project/ansible/
.. _Ansible Galaxy: https://galaxy.ansible.com
.. _Ansible Vault: https://docs.ansible.com/ansible/latest/user_guide/vault.html
.. _Kubernetes: https://kubernetes.io
