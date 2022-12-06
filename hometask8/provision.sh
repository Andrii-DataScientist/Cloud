#!/bin/bash

--threshold 2 --comparison-operator LessThanLowerThreshold

LB_ARN=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[*].LoadBalancerArn' --output text)
echo $LB_ARN
TG_ARN=$(aws elbv2 describe-target-groups --query 'TargetGroups[*].TargetGroupArn' --output text)
echo $TG_ARN
INST1_ID=$(aws ec2 describe-instances --query 'Reservations[-1].Instances[*].[InstanceId]' --filters Name=instance-state-name,Values=running --output text)
INST2_ID=$(aws ec2 describe-instances --query 'Reservations[-2].Instances[*].[InstanceId]' --filters Name=instance-state-name,Values=running --output text)
echo $INST1_ID
echo $INST2_ID