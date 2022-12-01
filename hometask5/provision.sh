#!/bin/bash

LB_ARN=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[*].LoadBalancerArn' --output text)
echo $LB_ARN
TG_ARN=$(aws elbv2 describe-target-groups --query 'TargetGroups[*].TargetGroupArn' --output text)
echo $TG_ARN
INST1_ID=$(aws ec2 describe-instances --query 'Reservations[-1].Instances[*].[InstanceId]' --filters Name=instance-state-name,Values=running --output text)
INST2_ID=$(aws ec2 describe-instances --query 'Reservations[-2].Instances[*].[InstanceId]' --filters Name=instance-state-name,Values=running --output text)
echo $INST1_ID
echo $INST2_ID
TOP_ARN=$(aws sns create-topic --name Lab5Topic --query 'TopicArn' --output text)
SUB_ARN=$(aws sns subscribe --topic-arn $TOP_ARN --protocol email --notification-endpoint avarenitsya@gmail.com --query 'SubscriptionArn' --output text)
aws cloudwatch put-metric-alarm --alarm-name ELB_HealthyHostCount --alarm-description "Alarm when target is deleted" --metric-name HealthyHostCount \
--namespace AWS/ApplicationELB --statistic SampleCount --period 10 --threshold 2 --comparison-operator LessThanThreshold --dimensions Name=LoadBalancerName,Value=app/Lab4LB/1436b78d32b3e889 \
Name=TargetGroup,Value=targetgroup/Lab4TG/e5784f52bbd1e635 --evaluation-periods 3 --alarm-actions $TOP_ARN --unit Count
