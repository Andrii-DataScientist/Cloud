#!/bin/bash

TOP_ARN=$(aws sns list-topics --query 'Topics[*].TopicArn' --output text)
ALARM_NAME=$(aws cloudwatch describe-alarms --query 'MetricAlarms[*].AlarmName' --output text)
aws sns delete-topic --topic-arn $TOP_ARN
aws cloudwatch delete-alarms --alarm-names $ALARM_NAME
