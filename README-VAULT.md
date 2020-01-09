# Encryption of sensitive data (Ansible Vault)
To run the playbooks you will need the [Ansible Vault] Password,
which can be found in **KeePass** (Under **Kubernetes > Ansible Vault Password**).

You can either put the password in the `vault-pass.txt` file in the project
root (protested from commit by `.gitignore`) or present it on the
command-line when you run the playbooks.

## Encrypted variables (parameters)
Parameters are stored in vault-encrypted files and these can be used by Ansible
directly. They can be edited in-situ while preserving the encrypted state of
the file. Armed with the repo's vault password you can edit any encrypted
parameter file with: -

    $ ansible-vault edit site-im-main-parameters.vault \
        --vault-password-file vault-pass.txt

---

[Ansible Vault]: https://docs.ansible.com/ansible/latest/user_guide/vault.html
