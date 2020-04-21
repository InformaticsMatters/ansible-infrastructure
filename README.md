# Ansible Infrastructure

[![Build Status](https://travis-ci.com/InformaticsMatters/ansible-infrastructure.svg?branch=master)](https://travis-ci.com/InformaticsMatters/ansible-infrastructure)
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/informaticsmatters/ansible-infrastructure)

Ansible roles to deploy Informatics Matters infrastructure components
(a database, keycloak and AWX) to [Kubernetes].

You'll find documentation written using [Sphinx] in the `doc` directory.

>   Refer to the Sphinx [primer] for a quick _cheat sheet_ of Sphinx
    formatting style

## Building the Documentation
The source of the documentation can be found in the project's
`doc` directory. To build the HTML version of the documentation install
the build requirements and then move to the `doc` directory and execute
`sphinx-build`: -

    $ pip install -r build-requirements.txt
    $ sphinx-build -b html doc doc/build

The resultant index page will be called `build/html/index.html`.

>   The build directory is currently excluded by the project's `.gitignore`

---

[kubernetes]: https://kubernetes.io
[sphinx]: http://www.sphinx-doc.org/en/master/#
[primer]: https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html#lists-and-quote-like-blocks
