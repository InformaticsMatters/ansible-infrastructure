# Ansible Infrastructure

![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/informaticsmatters/ansible-infrastructure)

![yamllint and doc build](https://github.com/InformaticsMatters/ansible-infrastructure/workflows/lint%20and%20doc%20build/badge.svg)

[![CodeFactor](https://www.codefactor.io/repository/github/informaticsmatters/ansible-infrastructure/badge)](https://www.codefactor.io/repository/github/informaticsmatters/ansible-infrastructure)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![Packaged with Poetry](https://img.shields.io/badge/packaging-poetry-cyan.svg)](https://python-poetry.org/)

Ansible roles to deploy Informatics Matters infrastructure components
(a database, keycloak and AWX) to [Kubernetes].

You'll find documentation written using [Sphinx] in the `doc` directory.

>   Refer to the Sphinx [primer] for a quick _cheat sheet_ of Sphinx
    formatting style

## Cluster provisioning
Most of this material relates to configuring Kubernetes clusters that
have been provisioned. For documentation relating to (some) cluster
provisioning refer to the `provisioning/README.md`.

## Cinder provisioner
The cinder provisioner is a 'work in progress' formed from Helm templates
taken from the [cloud-provider-openstack] repository. The release used
as a basis of the templates was **openstack-cinder-csi-1.1.2**.

## Building the Documentation
The source of the documentation can be found in the project's
`doc` directory. To build the HTML version of the documentation install
the build requirements and then move to the `doc` directory and execute
`sphinx-build`: -

    sphinx-build -b html doc doc/build

The resultant index page will be called `doc/build/index.html`.

>   The build directory is currently excluded by the project's `.gitignore`

---

[kubernetes]: https://kubernetes.io
[sphinx]: http://www.sphinx-doc.org/en/master/#
[primer]: https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html#lists-and-quote-like-blocks
[cloud-provider-openstack]: https://github.com/kubernetes/cloud-provider-openstack
