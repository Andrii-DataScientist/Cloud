#!/bin/bash

TOP_ARN=$(aws sns create-topic --name load_balancer_health --query 'TopicArn' --output text)
SUB_ARN=$(aws sns subscribe --topic-arn $TOP_ARN --protocol email --notification-endpoint avarenitsya@gmail.com --query 'SubscriptionArn' --output text)
aws cloudwatch put-metric-alarm --alarm-name ELBHealth --alarm-description "Alarm when instance in target group is deleted" --metric-name HealthyHostCount \
--namespace AWS/ApplicationELB --statistic Average --period 60 --threshold 2 --comparison-operator LessThanThreshold --dimensions \
Name=TargetGroup,Value=targetgroup/Lab4TG/f1379070d8a9b811 Name=LoadBalancer,Value=app/Lab4LB/ecbd0c0e36cd509c --evaluation-periods 1 --alarm-actions $TOP_ARN
