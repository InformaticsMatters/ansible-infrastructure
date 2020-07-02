# eksctl (AWS)

For background, refer to the official notes for eksctl: -

    https://eksctl.io

>   These notes were based on eksctl v0.22.0 and kubectl v1.18.5
    
1.  Before progressing read teh AWS [Getting Started] guide for **eksctl**
    and review the [examples], which may provide some useful excerpts.

2.  Ensure you've configured the AWS CLI with a **im** profile
    in ~/.aws/credentials. i.e.: -

    [im]
    aws_access_key_id = 0000000
    aws_secret_access_key = 0000000
    region = eu-central-1

3.  Edit the cluster.yaml file to ensure it satisfies your needs
    (if you need to SSH yu'll need the private part of the public key provided)
    and then create the cluster from this directory: -
    
    $ eksctl create cluster -f cluster.yaml --auto-kubeconfig -p im
    [ℹ]  eksctl version 0.22.0
    [...]
    
    At the end of the process (10-15 minutes) you should have a viable cluster
    and a kubernetes configuration file located `~/.kube/eksctl/clusters/im-main`
    
    $ export KUBECONFIG=$HOME/.kube/eksctl/clusters/im-main
    $ kubectl get no
    
>   kubectl may not work with profiles so if you're getting
    `error: You must be logged in to the server (Unauthorized)` then
    try setting the classic environment variables: -
    
    $ export AWS_ACCESS_KEY_ID=0000
    $ export AWS_SECRET_ACCESS_KEY=0000
    
---

[getting started]: https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html
[examples]: https://github.com/weaveworks/eksctl/tree/master/examples
