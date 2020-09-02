***************************
Deleting the Infrastructure
***************************

..  warning::
    Remember to consider un-deploying any of your application software first.
    It might have created Kubernetes objects that may be left *dangling*
    when the infrastructure is remove.

If you're familiar with :doc:`creating-the-infrastructure` deleting is
simple, using the ``unsite.yaml`` playbook, combined with a set of parameters
that corresponds to your cluster::

    $ INFRA_NAME=im-main
    $ ansible-playbook \
        -e "@parameters-$INFRA_NAME.vault" \
        unsite.yaml \
        --ask-vault-pass

But, remember, *with great power comes great responsibility*. Running the
``unsite.yaml`` playbook will delete the entire infrastructure; its namespace,
database, the AWX server and the certificate manager.
**Everything will be lost** so delete with extreme caution.

If you've used your own parameter file you probably don't need to use vault::

    $ INFRA_NAME=me
    $ ansible-playbook \
        -e "@parameters-$INFRA_NAME" \
        unsite.yaml

..  note::
    It is worth checking that resources external to the cluster that should
    also have been removed. This might include the **Network Load Balancer**
    and **Elastic File System**. You'll be charged for these until they're
    removed.
