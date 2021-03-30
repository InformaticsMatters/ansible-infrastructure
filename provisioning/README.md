# Kubernetes Provisioning
(Brief) notes relating to Kubernetes cluster provisioning.
The RKE notes relate to creating the small cluster to host a
Rancher deployment. Other directories relate to the formation
of clusters directly (generally on cloud-specific providers like AWS).

Individual directories should have their own `README.md` files.

>   Most instruction assume you're using the project requirements in
    Conda or a virtual environment.

## Ingress controller and ELB (AWS)
With a _bare_ cluster ready you can install an nginx ingress controller
DaemonSet and AWS NLB by applying the YAML provided in this directory.
It's a [copy] of the kubernetes [ingress-nginx] with a few minor tweaks.

Simply run the following from this directory: -

    $ kubectl apply -f ingress-controller/ingress-nginx-2.9.1.yaml

After a while your AWS NLB should be ready.

## rke-aws
Our RKE provisioning material.

---

[copy]: https://raw.githubusercontent.com/kubernetes/ingress-nginx/ingress-nginx-2.9.1/deploy/static/provider/aws/deploy.yaml
[eks-im-main]: https://gitlab.com/informaticsmatters/eks-im-main
[ingress-nginx]: https://github.com/kubernetes/ingress-nginx
