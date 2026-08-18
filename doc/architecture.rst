************
Architecture
************

The Ansible Infrastructure project is a set of roles that are used to
deploy Informatics Matters infrastructure applications (in the form of
containers) to a Kubernetes cluster.

..  note::
    The infrastructure playbooks do not deploy an *Ingress Controller* but the
    architecture uses **Ingress** objects that rely on an **NGINX Ingress
    Controller** in the cluster.

    If you have not installed the NGINX ingress controller you can use the
    one in our ``provisioning`` directory and refer to the ``README.md``
    file there.

The architecture consists of the following components, in approximate order
of creation, and described briefly in the following sections: -

*   The **Kubernetes Certificate Manager**, managed by the
    ``informaticsmatters.cert_manager`` Role, a Role deployed to Ansible Galaxy
    and maintained in our `cert manager`_ GitHub repository
*   **Pod Security Policies**, managed by this repository's ``core`` Role
*   An OpenStack **Cinder** *provisioner*, managed by this
    repository's ``provisioner-cinder`` Role
*   An AWS **Elastic File System** *provisioner*, managed by this
    repository's ``provisioner-efs`` Role
*   An **NFS** *provisioner*, managed by this
    repository's ``provisioner-nfs`` Role
*   A **PosgreSQL** database, managed by this repository's ``infrastructure`` Role
*   A cron-like **Database Backup** process
*   An **AWX** server, managed by this repository's ``infrastructure`` Role
*   A **Keycloak** identity management instance, managed by this repository's
    ``infrastructure`` Role
*   A **Database Recovery** Role

Additionally there are playbooks to simplify the provisioning on a base `RKE`_
cluster for the installation of `Rancher`_ and a role to prepare an NFS server: -

*   ``site-rke.yaml``
*   ``site-nfs.yaml``

Kubernetes Certificate Manager
==============================

Our `Cert Manager`_ repository relies on a cut of the official
`Kubernetes Cert Manager`_ project to provide our cluster with automatic and
free certificates, driven by annotations within corresponding **Ingress**
definitions. Rather than depend on the certificate
manager directly we have an Role (in Ansible Galaxy) that has taken
version ``0.12.0`` of the Kubernetes certificate manager and adjusts it to
work in our cluster.

The certificate manager is driven by **Ingress** object annotations that are
used to automatically create and refresh both *staging* and *production*
certificates.

Pod Security Policies
=====================

Deployed applications rely on the Pod Security Policies deployed by this
project's ``core`` Role. PSPs provide deployments with privileges required
to run containers. We provide the following PSPs: -

*   ``im-core-unrestricted`` - a fully open policy

Cinder Provisioner
==================

Using the ``cinder`` provisioner available to Kuberneetes, our
``provisioner-cinder`` Role in this repository configures the cluster with the
ability to create Read-Write Once volumes using the OpenStack cinder
service. The role also creates, amongst other things: -

*   A **StorageClass** that can be used by application
    **Persistent Volume Claims** to create volumes that will be *deleted*
    when released
*   A **StorageClass** that can be used by application
    **Persistent Volume Claims** to create volumes that will be *retained*
    when released

Elastic File System Provisioner
===============================

Using the ``ec2`` and ``efs`` module built into Ansible, our ``provisioner-efs``
Role in this repository configures the cluster's security group to allow access
to an AWS EFS instance. The role also creates, amongst other things: -

*   A **Namespace** in which the EFS provisioner is deployed
*   A **StorageClass** called ``efs`` that can be used by application
    **Persistent Volume Claims**

EFS is used by Squonk for *Read Write Many* volume access in order to run
pipelines.

Network File System Provisioner
===============================

Using the ``nfs`` provisioner available to Kuberneetes, our ``provisioner-efs``
Role in this repository configures the cluster with an NFS provisioner.
The role also creates, amongst other things: -

*   A **Namespace** in which the NFS provisioner is deployed
*   A **StorageClass** called ``nfs`` that can be used by application
    **Persistent Volume Claims**

NFS is used by Squonk for *Read Write Many* volume access in order to run
pipelines.

PostgreSQL
==========

The ``infrastructure`` Role in this repository creates a **Namespace**
and deploys a **PostgreSQL** container (a ``12.1-alpine`` image by default)
with an AWS GP2 EBS volume for persistent storage.

Deployment fo the database is hard-coded into the role, the database is
not optional.

PostgreSQL Backups
==================

A backup strategy, relying on our *backup and recovery* container images,
is optionally deployed. By default it is deployed and creates a full database
backup at 7 minutes past each hour, keeping the last 24 backups.

For more details refer to the documentation in ``backup.py`` in our
`Backup and Recovery`_ repository.

PostgreSQL Velero Backups
=========================

Optionally, and in addition to the backup strategy above, the database can be
prepared for backup and recovery with `Velero`_. Set ``pg_velero_state`` to
``present`` and the ``infrastructure`` Role will: -

*   Create a **Persistent Volume Claim** (``pg-velero`` by default) for a
    ``pg_dumpall`` file, mounted at ``/velero`` in the database container
*   Annotate the database **Pod** with Velero *backup* and *restore* hooks

Velero is expected to be installed on the cluster - it is not deployed by
this repository.

We back up a database dump rather than the database's binary files because
a copy of the binary files does not necessarily restore to a viable database.
The ``backup.velero.io/backup-volumes`` annotation therefore hands Velero the
dump volume, and the hooks keep that volume's dump up to date: -

*   The **pre-backup** hook removes any existing dump and then writes a new
    one with ``pg_dumpall``
*   The **post-restore** hook waits for the recovered database, replays the
    dump into it with ``psql``, and then removes the dump (the next backup
    writes a new one)

The ``pg_velero_backup_timeout`` and ``pg_velero_restore_timeout`` variables
limit how long Velero gives each hook - increase them for large databases.

Keycloak
========

Optionally, and using the deployed PostgreSQL database, the ``infrastructure``
Role deploys an instance of **Keycloak** (version ``8.0.1`` by default).

variables, typically defined in the corresponding encrypted parameter file,
(see :doc:`creating-the-infrastructure`) define the Keycloak **Admin** ``user``,
``password`` and Keycloak server ``URL``, which will be routed to the
Keycloak **Ingress** object.

Deploying keycloak is optional.

AWX
===

Optionally, and using the deployed PostgreSQL database, the ``infrastructure``
Role deploys an instance of **AWX** (version ``9.1.1`` by default).

variables, typically defined in the corresponding encrypted parameter file,
(see :doc:`creating-the-infrastructure`) define the AWX **Admin** ``user``,
``password`` and server ``URL``, which will be routed to the
AWX **Ingress** object.

Deploying AWX is optional.

Database Recovery
=================

The ``infrastructure-recovery`` role in this repository, with the
``site-infrastructure-recovery.yaml`` playbook can be used to restore the
infrastructure database from a pre-existing backup.

The ``recovery_from_backup`` variable is used to define the backup used as
the source of the recovery.

For more details refer to the documentation in ``recovery.py`` in our
`Backup and Recovery`_ repository.

.. _AWX: https://github.com/ansible/awx
.. _Backup and recovery: https://github.com/InformaticsMatters/bandr
.. _Cert Manager: https://github.com/InformaticsMatters/ansible-role-cert-manager
.. _Kubernetes Cert Manager: https://github.com/jetstack/cert-manager
.. _Rancher: https://rancher.com
.. _RKE: https://rancher.com/docs/rke/latest/en/
.. _Velero: https://velero.io
