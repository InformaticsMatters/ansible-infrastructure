# Ansible Infrastructure

[![Build Status](https://travis-ci.com/InformaticsMatters/ansible-infrastructure.svg?branch=master)](https://travis-ci.com/InformaticsMatters/ansible-infrastructure)
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/informaticsmatters/ansible-infrastructure)

An Ansible role to deploy Informatics Matters infrastructure components
(a database, keycloak and AWX) to [Kubernetes].

Ideally you'll start from a Python 3.8 virtual environment and then install
the required modules, roles and collections: -

    $ conda activate ansible-infrastructure
    $ pip install -r requirements.txt
    $ ansible-galaxy install -r role-requirements.yaml --force-with-deps
    $ ansible-galaxy collection install -r collection-requirements.yaml --force-with-deps

## Cluster pre-requisites
Your cluster will need: -

1.  A **StorageClass** for the infrastructure database (postgres).
    You will define the name of the cluster's storage class
    in parameters you pass to the playbook
    (see the **Creating** section below).
1.  To help organise Pod deployment you should have nodes
    with the label `purpose=application`. This is not mandatory,
    but recommended.
1.  Domain names should be routed to your cluster.
    You will set the actual names using parameters but you should have
    resolvable domain names for infrastructure components that will be deployed
    (e.g. domains for the **AWX** and **Keycloak** services).
 
## Cluster credentials
You should be in possession of a Kubernetes configuration file. Plays run
from within AWX benefit from the automatic injection of Kubernetes variables.
Once installed our AWX will inject the following environment variables: -

-   `K8S_AUTH_HOST`
-   `K8S_AUTH_API_KEY`
-   `K8S_AUTH_VERIFY_SSL`

As we're deploying the infrastructure components (from outside AWX)
we need to provide values for these. The `HOST` is the **cluster -> server**
value of your control plane from the config file and `API_KEY` is the
**user-> token** value: -

    $ export K8S_AUTH_HOST=https://1.2.3.4:6443
    $ export K8S_AUTH_API_KEY=kubeconfig-user-abc:00000000
    $ export K8S_AUTH_VERIFY_SSL=no

>   If you intend to use `kubectl` you will need to set `KUBECONFIG` variable
    to point to a local copy of the cluster config file. You can safely place
    the config in the root of a clone of this repository as the file
    `kubeconfig` as this is part fo the project ignore set.

    $ export KUBECONFIG=./kubeconfig

You will also need to provide standard AWS credentials for the cluster you're
configuring via the environment for some of the Roles to properly function: -

    $ export AWS_ACCESS_KEY_ID=xxxxxxxxxxxx
    $ export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxx
    
## Creating
You may need to adjust some deployment parameters to suit you needs.
Do this by creating a `parameters` file using `parameters.template`
as an example: -

    $ cp parameters.template parameters
    $ [edit parameters]

And then, using the parameter file, deploy the infrastructure: -

    $ ansible-playbook -e "@parameters" site.yaml

If your parameters are encrypted with Ansible [vault] you can use them
directly, without needing to decrypt them: -

    $ ansible-playbook -e "@site-im-main-parameters.vault" site.yaml \
        --vault-password-file vault-pass.txt

### Plays
The following plays are supported, captured in corresponding `site*.yaml`
playbook files: -

-   `site` (for infrastructure deployment)
-   `site-infrastructure-recovery` (to recover database content from a backup)

## Deleting the infrastructure
Be careful here, you'll delete the entire infrastructure; its namespace,
database, the AWX server and the certificate manager (if deployed): -

    $ ansible-playbook -e "@site-im-main-parameters.vault" unsite.yaml \
        --vault-password-file vault-pass.txt

## Using Ansible Vault to preserve parameters
Site parameter files can be stored in `.vault` files. These will be written
to revision control but their un-encrypted versions will not. This only works
if your sensitive (unencrypted) parameter files end with the word `parameters`.

>   You can deploy directly without having to decrypt the encrypted parameter
    file.

---

[kubernetes]: https://kubernetes.io
[vault]: https://docs.ansible.com/ansible/latest/user_guide/vault.html
