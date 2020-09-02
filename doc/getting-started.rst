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

    $ pip install -r requirements.txt
    $ ansible-galaxy install -r role-requirements.yaml --force-with-deps
    $ ansible-galaxy collection install -r collection-requirements.yaml --force-with-deps

Cluster (Kubernetes) pre-requisites
===================================

Your Kubernetes cluster will need: -

1.  A **StorageClass** for the infrastructure database (postgres).
    You will define the name of the cluster's storage class
    (typically ``gp2``) in parameters you pass to the playbook.

2.  **Node labels**. To help organise Pod deployment you should have nodes
    with the label ``purpose=application``. This is not mandatory,
    but recommended.

3.  An **NGINX Ingress Controller**. In order to load-balance and route traffic
    into and around the cluster we rely on an NGINX ingress controller
    and the annotations it supports in Kubernetes **Ingress** objects.
    If you have not already installed NGINX as an ingress controller
    you can use the one pre-packaged in our ``provisioning`` directory and
    refer to our ``provisioning/README.md``.

4.  **Domain names** should be routed to your cluster's Load Balancer (normally
    automatically created by the installation of an NGINX Ingress Controller -
    see above). You will set the actual names using parameters but you should
    have resolvable domain names for infrastructure components that will be
    deployed (e.g. domains for the **AWX** and **Keycloak** services if you're
    using them).

Cluster credentials
===================

You should be in possession of a Kubernetes configuration file. Plays run
from within AWX benefit from the automatic injection of Kubernetes variables.
Once installed our AWX will inject the following environment variables: -

-   ``K8S_AUTH_HOST``
-   ``K8S_AUTH_API_KEY``
-   ``K8S_AUTH_VERIFY_SSL``
-   ``K8S_CONTEXT``

As we're deploying the infrastructure components (from outside AWX)
we need to provide values for these. The ``HOST`` is the **cluster -> server**
value of your control plane from the config file and ``API_KEY`` is the
**user-> token** value::

    $ export K8S_AUTH_HOST=https://1.2.3.4:6443
    $ export K8S_AUTH_API_KEY=kubeconfig-user-abc:00000000
    $ export K8S_AUTH_VERIFY_SSL=no
    $ export K8S_CONTEXT=im-main

To confirm you have the right context you can always run the following
command to list the valid contexts::

    $ kubectl config get-contexts

You will also need a copy of your **kubeconfig** file and will need to set the
``KUBECONFIG`` environment variable to point to your copy. You can safely place
the config in the root of a clone of this repository as the file
``kubeconfig`` as this is part of the project ignore set::

    $ export KUBECONFIG=./kubeconfig

You will also need to provide standard AWS credentials for the cluster you're
configuring via the environment for some of the Roles to properly function::

    $ export AWS_ACCESS_KEY_ID=xxxxxxxxxxxx
    $ export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxx


The permissions of the AWS user will depend on what you intend to deploy.
Typically these will be something like: -

*   AmazonEC2FullAccess
*   AmazonElasticFileSystemFullAccess
*   AmazonS3ReadOnlyAccess

Verify you're using the right Kubernetes cluster with a quick node check,
assuming you know the identity of the nodes in the cluster you expect to be
configuring, using ``kubectl``::

    $ kubectl get no
    NAME                       STATUS   ROLES          AGE     VERSION
    xch-production-app1        Ready    worker         3d11h   v1.17.5
    xch-production-app2        Ready    worker         3d11h   v1.17.5
    xch-production-ctrl1       Ready    controlplane   3d15h   v1.17.5
    xch-production-ctrl2       Ready    controlplane   3d16h   v1.17.5
    xch-production-etcd1       Ready    etcd           3d13h   v1.17.5
    xch-production-etcd2       Ready    etcd           3d15h   v1.17.5
    xch-production-etcd3       Ready    etcd           3d16h   v1.17.5
    xch-production-graph-sm1   Ready    worker         3d16h   v1.17.5

Vault passwords (optional)
--------------------------

..  note::
    Some pre-defined infrastructure parameter files, which contain preset
    deployment variable values, require an `Ansible Vault`_ password so that
    they can be decrypted. If you are using one of our built-in parameter files
    you will need the appropriate vault password.

Find the vault password for the parameter file you're interested in
(normally found in our **KeePass** application). And place it in a file called
``vault-pass.txt`` in the root of this project.

.. _Ansible: https://pypi.org/project/ansible/
.. _Ansible Galaxy: https://galaxy.ansible.com
.. _Ansible Vault: https://docs.ansible.com/ansible/latest/user_guide/vault.html
.. _Kubernetes: https://kubernetes.io
