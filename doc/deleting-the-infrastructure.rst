***************************
Deleting the Infrastructure
***************************

If you're familiar with :doc:`creating-the-infrastructure` deleting is
simple, using the ``unsite.yaml`` playbook, combined with a set of parameters
that corresponds to your cluster::

    $ ansible-playbook -e "@site-im-main-parameters.vault" unsite.yaml \
        --vault-password-file vault-pass.txt

But, remember, *with great power comes great responsibility*. Running the
``unsite.yaml`` playbook will delete the entire infrastructure; its namespace,
database, the AWX server and the certificate manager.
**Everything will be lost** so delete with extreme caution.
