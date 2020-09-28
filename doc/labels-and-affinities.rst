##########################
Node Labels and Affinities
##########################

What follows is our Kubernetes cluster node lebeling and Pod scheduling policy,
originally described in Clubhouse story `ch1312`_. The detailed reasoning will
be left to the Clubhouse story, here we'll just summarise labels and affinities
(Pod requirements).

Labels
======

*   ``informaticsmatters.com/purpose=core``
*   ``informaticsmatters.com/purpose=application``
*   ``informaticsmatters.com/purpose=worker``

Node affinities
===============

Core pods
---------
Pods that need a core node, i.e. those that have a persistence
requirement like our infrastructure database, should define a
``requiredDuringSchedulingIgnoredDuringExecution`` *Node Affinity* rule in the
corresponding Pod spec.

This will force the Kubernetes scheduler to place the Pod on a core node.

.. code-block:: yaml

    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: informaticsmatters.com/purpose
                operator: In
                values:
                - core

Application pods
----------------
Pods that do not need a core node, i.e. those that do not need persistence
or have their own zone-agnostic persistence, should define a
``requiredDuringSchedulingIgnoredDuringExecution`` and a
``preferredDuringSchedulingIgnoredDuringExecution`` *Node Affinity* rule in the
corresponding Pod spec.

This will force the scheduler to avoid worker nodes and prefer
application nodes, but with a fall-back to a core node if an application node
is not available.

.. code-block:: yaml

    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: informaticsmatters.com/purpose
                operator: NotIn
                values:
                - worker
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 1
            preference:
              matchExpressions:
              - key: informaticsmatters.com/purpose
                operator: In
                values:
                - application

Transient application services, Jobs, CronJobs with zone-agnostic persistence
or no persistence requirements at all can use a less complex
affinity, this one simply avoiding a core node (shown below),
or by not providing any affinity at all - letting the Pod appear anywhere
resources allow.

.. code-block:: yaml

    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: informaticsmatters.com/purpose
                operator: NotIn
                values:
                - core

Worker pods
-----------
Transient workload Pods that do not need a core node (like a nextflow process)
should define a `requiredDuringSchedulingIgnoredDuringExecution`
*Node Affinity* rule in the corresponding Pod spec to force the scheduler
to place the Pod on worker nodes: -

.. code-block:: yaml

    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: informaticsmatters.com/purpose
                operator: In
                values:
                - worker

.. _ch1312: https://app.clubhouse.io/informaticsmatters/story/1312/pod-scheduling-and-node-label-policy
