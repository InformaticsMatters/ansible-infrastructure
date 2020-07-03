# RKE (AWS)

Based on the following Rancher notes: -

    https://rancher.com/blog/2018/2018-05-14-rke-on-aws/
 
>   NOTES: Creating a single "all-in-one" cluster was not successful and
    investigation paused as we switched to eksctl. If we return to this
    and the installation is successful this note will be removed.

1.  The aws-rke-prep.sh script prepares AWS with a Role etc.
    Run this first.

2.  Provision nodes using the AWS console
    In our case we create an Ubuntu Server 16.04 LTS (HVM),
    SSD Volume Type - ami-05ed2c1359acd8af6
    on a t3a.large machine (2 cores, 8Gi RAM)
    and an 40Gi root volume using the IAM role rke-role (created above)
    and a key-pair you're familiar with.

    You must ensure the following ports are open for inbound traffic
    See https://rancher.com/docs/rancher/v2.x/en/installation/requirements/ports/

    ...and any other inbound ports you might need,
    like http/https (80, 443) etc.

3.  Tag EC2 instances with: -

    Key: kubernetes.io/cluster/<CLUSTERID>
    Value: owned

    Where <CLUSTERID> can be any string you choose.

4.  Adjust this project's inventory.yaml for the rke group
    and run our rke role to setup Docker and NTP: -

    $ ansible-playbook site-rke.yaml

5. Adjust our aws-rke-cluster.yaml run RKE: -

   $ rke up --config aws-rke-cluster.yaml
 