#!/bin/bash

VPC_ID=$(aws ec2 describe-vpcs --query 'Vpcs[0].VpcId' --output text) \
&& NET1_ID=$(aws ec2 describe-subnets --query 'Subnets[0].SubnetId' --output text) \
&& NET2_ID=$(aws ec2 describe-subnets --query 'Subnets[1].SubnetId' --output text) \
&& SG=$(aws ec2 describe-security-groups --query 'SecurityGroups[0].GroupId' --output text) \
&& LB_ARN=$(aws elbv2 create-load-balancer --name Lab4LB --subnets $NET1_ID $NET2_ID --security-group $SG --output text)\
&& TG_ARN=$(aws elbv2 create-target-group --name Lab4TG --protocol HTTP --port 80 --vpc-id $VPC_ID --ip-address-type ipv4 --output text) \
&& IMAGE_ID=$(aws ec2 describe-images --owners 577299593433 --query 'Images[*].ImageId' --output text) \
&& INST1_ID=$(aws ec2 run-instances --image-id IMAGE_ID --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids $SG --query 'Instances[*].[InstanceId]' --output text) \
&& INST2_ID=$(aws ec2 run-instances --image-id IMAGE_ID --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids $SG --query 'Instances[*].[InstanceId]' --output text) \
&& aws elbv2 register-targets --target-group-arn $TG_ARN --targets Id=$INST1_ID Id=$INST2_ID \
&& aws elbv2 create-listener --load-balancer-arn $LB_ARN --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=$TG_ARN \
&& aws elbv2 describe-target-health --target-group-arn $TG_ARN \
&& aws autoscaling create-auto-scaling-group --auto-scaling-group-name Lab4ASG --min-size 2 --max-size 2 --desired-capacity 2 --target-group-arns $TG_ARN \
&& aws autoscaling describe-load-balancer-target-groups --auto-scaling-group-name Lab4ASG \
&& aws autoscaling update-auto-scaling-group --auto-scaling-group-name Lab4ASG --health-check-type ELB --health-check-grace-period 15