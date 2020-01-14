# Ansible Infrastructure

[![Build Status](https://travis-ci.com/InformaticsMatters/ansible-infrastructure.svg?branch=master)](https://travis-ci.com/InformaticsMatters/ansible-infrastructure)

An Ansible role to deploy Informatics Matters infrastructure components
(a database, keycloak and AWX) to [Kubernetes].

Ideally you'll start from a Python 3 virtual environment and then install
the required modules, roles and collections: -

    $ conda activate ansible-infrastructure
    $ pip install -r requirements.txt
    $ ansible-galaxy install -r role-requirements.yaml
    $ ansible-galaxy collection install -r collection-requirements.yaml

## Kubernetes preparation
You should be in possession of a Kubernetes configuration file. This is often
the content of the `config` file in your `~/.kube` directory. You can place the
configuration file anywhere, and you would place it somewhere else if you
want to preserve your existing `~/.kube/config`. If you're not using
`~/.kube/config` set the `KUBECONFIG` environment variable to its path: -

    $ export KUBECONFIG=/Users/abc/infra-config

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
-   `site-infrastructure_create-user-db` (to create a database user and database)
-   `site-infrastructure_alter-user-password` (to change a database user password)
-   `site-infrastructure_delete-user-db` (to delete a database user and database)
-   `site-infrastructure-recovery` (to recover database content from a backup)

## Deleting the infrastructure
Be careful here, you'll delete the entire infrastructure; its namespace,
database, the AWX server and the certificate manager (if deployed): -

    $ ansible-playbook -e "@parameters" unsite.yaml

## Using Ansible Vault to preserve parameters
Site parameter files can be stored in `.vault` files. These will be written
to revision control but their un-encrypted versions will not. This only works
if your sensitive (unencrypted) parameter files end with the word `parameters`.

>   You can deploy directly without having to decrypt the encrypted parameter
    file.

---

[kubernetes]: https://kubernetes.io
[vault]: https://docs.ansible.com/ansible/latest/user_guide/vault.html
