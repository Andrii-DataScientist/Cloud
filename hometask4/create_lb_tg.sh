#!/bin/bash

VPC_ID=$(aws ec2 describe-vpcs --query 'Vpcs[0].VpcId' --output text) 
NET1_ID=$(aws ec2 describe-subnets --query 'Subnets[0].SubnetId' --output text) 
NET2_ID=$(aws ec2 describe-subnets --query 'Subnets[-1].SubnetId' --output text) 
SG=$(aws ec2 describe-security-groups --query 'SecurityGroups[-1].GroupId' --output text)
NEW_SG=$(aws ec2 describe-security-groups --query 'SecurityGroups[-3].GroupId' --output text)
LB_ARN=$(aws elbv2 create-load-balancer --name Lab4LB --subnets $NET1_ID $NET2_ID --security-group $SG --query 'LoadBalancers[*].LoadBalancerArn' --output text)
TG_ARN=$(aws elbv2 create-target-group --name Lab4TG --protocol HTTP --port 80 --vpc-id $VPC_ID --query 'TargetGroups[*].TargetGroupArn' --output text) 
IMAGE_ID=$(aws ec2 describe-images --owners 577299593433 --query 'Images[*].ImageId' --output text) 
INST1_ID=$(aws ec2 run-instances --image-id $IMAGE_ID --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids $NEW_SG --query 'Instances[-1].[InstanceId]' --output text) 
INST2_ID=$(aws ec2 run-instances --image-id $IMAGE_ID --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids $NEW_SG --query 'Instances[-1].[InstanceId]' --output text)
echo $SG
echo $INST1_ID
echo $INST2_ID