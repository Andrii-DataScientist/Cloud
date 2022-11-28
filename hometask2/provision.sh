#!/bin/bash

aws ec2 create-vpc --cidr-block 10.0.0.0/16 \
vpc_id=$(aws ec2 describe-vpcs --query 'Vpcs[0].VpcId' --output text) \
aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.1.0/24 \
net1_id=$(aws ec2 describe-subnets --query 'Subnets[0].SubnetId' --output text) \
aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.2.0/24 \
aws ec2 create-internet-gateway \
igw=$(aws ec2 describe-internet-gateways --query 'InternetGateways[0].InternetGatewayId' --output text) \
aws ec2 attach-internet-gateway --internet-gateway-id $igw --vpc-id $vpc_id \
aws ec2 allocate-address --domain vpc \
alloc_id=$(aws ec2 describe-addresses --query 'Addresses[1].AllocationId' --output text) \
aws ec2 create-nat-gateway --subnet-id $net1_id --allocation-id $alloc_id \
nat=$(aws ec2 describe-nat-gateways --query 'NatGateways[-1].NatGatewayId' --output text) \
aws ec2 create-route-table --vpc-id $vpc_id \
rtb_id=$(aws ec2 describe-route-tables --query 'RouteTables[0].RouteTableId' --output text) \
#aws ec2 create-tags --resources rtb-0eccbda8bf2f7772d --tags Key=Name,Value=cli-rtbPublic \
aws ec2 create-route --route-table-id $rtb_id --destination-cidr-block 0.0.0.0/0 --gateway-id $igw \
aws ec2 associate-route-table --route-table-id $rtb_id --subnet-id $net1_id \
aws ec2 create-security-group --group-name security-group --description "security group for instances" --vpc-id $vpc_id \
sg=$(aws ec2 describe-security-groups --query 'SecurityGroups[0].GroupId' --output text) \
aws ec2 authorize-security-group-ingress --group-id $sg --protocol tcp --port 22 --cidr 0.0.0.0/0 \
aws ec2 create-key-pair --key-name cli-PrivateKey --query 'KeyMaterial' --output text > cli-PrivateKey.pem \
chmod 400 cli-PrivateKey.pem \
aws ec2 run-instances --image-id ami-0533f2ba8a1995cf9 --instance-type t2.micro --count 1 --subnet-id $net1_id --security-group-ids $sg --associate-public-ip-address --key-name cli-PrivateKey \
instance_id=$(aws ec2 describe-instances --instance-ids --query 'Reservations[0].Instances[0].InstanceId' --output text) \
aws ec2 modify-vpc-attribute --enable-dns-hostnames --vpc-id $vpc_id \
log=$(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[].Instances[].PublicDnsName' --output text) \
ssh -i "cli-PrivateKey.pem" ec2-user@$log
