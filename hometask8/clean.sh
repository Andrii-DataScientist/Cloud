#!/bin/bash
FUNC_NAME=$(aws lambda list-functions --query 'Functions[0].FunctionName' --output text)
aws lambda delete-function --function-name $FUNC_NAME
aws iam delete-policy --policy-arn arn:aws:iam::577299593433:policy/AWSLambdaS3Policy
aws iam delete-role --role-name lambda-s3-role
# aws s3 rm s3://lab8-srcbucket-1webqqrkevc1i --recursive
# aws s3 rb s3://lab8-srcbucket-1webqqrkevc1i
aws s3 rm s3://andrii-lab8 --recursive
aws s3 rb s3://andrii-lab8
aws s3 rm s3://andrii-lab8-resized --recursive
aws s3 rb s3://andrii-lab8-resized
