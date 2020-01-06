# Ansible Infrastructure
An Ansible role to deploy Informatics Matters infrastructure components
(a database, keycloak and AWX) to Kubernetes.

Ideally you'll start from a Python 3 virtual environment and then install
the required modules, roles and collections: -

    $ conda activate ansible-infrastructure
    $ pip install -r requirements.txt
    $ ansible-galaxy install -r role-requirements.yml
    $ ansible-galaxy collection install -r collection-requirements.yml

## Kubernetes preparation
You should be in possession of a Kubernetes configuration file. This is often
the content of the `config` file in your `~/.kube` directory. You can place the
configuration file anywhere, and you would place it somewhere else if you
want to preserve your existing `~/.kube/config`. If you're not using
`~/.kube/config` set the `KUBECONFIG` environment variable to its path: -

    $ export KUBECONFIG=/Users/abc/infra-config

## Cluster pre-requisites
Your cluster will need: -

1.  A **StorageClass** for the infrastructure database (postgres),
    you will define the name of the cluster storage class
    in parameters you pass to the playbook (see the **Deploying** section below).
1.  To help organise Pod deployment you should have nodes
    with the label `purpose=application`. This is not mandatory,
    but recommended.
1.  Domain names should be routed to your cluster. You will set these
    using parameters but you should have resolvable domain names
    for infrastructure components that will be deployed (e.g. **AWX** and
    **Keycloak**).
 
## Creating
You may need to tailor some deployment parameters to suit you needs.
Do this by creating a `parameters` file using `parameters.template`
as an example: -

    $ cp parameters.template parameters
    $ [edit parameters]

And then, using the parameter file, deploy the infrastructure: -

    $ ansible-playbook -e "@parameters" site.yml

## Deleting the infrastructure
Be careful here, you'll delete the infrastructure namespace, its database
and certificate manager: -

    $ ansible-playbook -e "@parameters" unsite.yml
