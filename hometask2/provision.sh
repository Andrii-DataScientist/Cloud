#!/bin/bash

aws ec2 create-vpc --cidr-block 10.0.0.0/16 \
  && aws ec2 create-subnet --vpc-id vpc-08277b311565d4db7 --cidr-block 10.0.1.0/24 \
  && aws ec2 create-subnet --vpc-id vpc-08277b311565d4db7 --cidr-block 10.0.2.0/24 \
  && aws ec2 create-internet-gateway \
  && aws ec2 attach-internet-gateway --internet-gateway-id igw-0f21dcfebba99465c --vpc-id vpc-08277b311565d4db7 \
  && aws ec2 allocate-address --domain vpc \
  && aws ec2 create-nat-gateway --subnet-id subnet-0291a8b7e01a1c6cf --allocation-id eipalloc-0b213c42f8da71faa \
  && aws ec2 create-route-table --vpc-id vpc-08277b311565d4db7 \
  && aws ec2 create-tags --resources rtb-0eccbda8bf2f7772d --tags Key=Name,Value=cli-rtbPublic \
  && aws ec2 create-route --route-table-id rtb-0eccbda8bf2f7772d --destination-cidr-block 0.0.0.0/0 --gateway-id igw-0f21dcfebba99465c \
  && aws ec2 associate-route-table --route-table-id rtb-0eccbda8bf2f7772d --subnet-id subnet-0291a8b7e01a1c6cf \
  && aws ec2 create-security-group --group-name security-group --description "security group for instances" --vpc-id vpc-08277b311565d4db7 \
  && aws ec2 authorize-security-group-ingress --group-id sg-06bbdb2177c8e6f23 --protocol tcp --port 22 --cidr 0.0.0.0/0 \
  && aws ec2 create-key-pair --key-name cli-keyPair --query 'KeyMaterial' --output text > cli-keyPair.pem \
  && chmod 400 cli-keyPair.pem \
  && aws ec2 run-instances --image-id ami-0533f2ba8a1995cf9 --instance-type t2.micro --count 1 --subnet-id subnet-0291a8b7e01a1c6cf --security-group-ids sg-06bbdb2177c8e6f23 --associate-public-ip-address --key-name cli-keyPair \
  && aws ec2 describe-instances --instance-ids i-0506860fa98abc9b3 --query 'Reservations[].Instances[].PublicDnsName' \
  && ssh -i "cli-keyPair.pem" ec2-user@ec2-35-153-144-199.compute-1.amazonaws.com
