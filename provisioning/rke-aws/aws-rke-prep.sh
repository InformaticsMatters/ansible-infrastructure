#!/usr/bin/env bash
#
# Alan Christie
# 30 Jun 2020
#
# Initial steps required to create a cluster for RKE/Rancher
# See https://rancher.com/blog/2018/2018-05-14-rke-on-aws/.
#
# These note were written using rke v1.1.3.
#
# The following assumes you have an AWS profile 'im'
# in ~/.aws/credentials. i.e.: -
#
#   [im]
#   aws_access_key_id = 0000000
#   aws_secret_access_key = 0000000
#   region = eu-central-1

set -e

aws --version

# Create an IAM role
aws --profile im iam create-role --role-name rke-role --assume-role-policy-document file://aws-rke-trust-policy.json
# Add our Access Policy
aws --profile im iam put-role-policy --role-name rke-role --policy-name rke-access-policy --policy-document file://aws-rke-access-policy.json
# Create the Instance Profile
aws --profile im iam create-instance-profile --instance-profile-name rke-aws
aws --profile im iam add-role-to-instance-profile --instance-profile-name rke-aws --role-name rke-role
