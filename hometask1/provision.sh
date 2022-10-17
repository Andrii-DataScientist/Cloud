#!/bin/bash

echo '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::andriiitsteplab1/*",
            "Condition": {
                "NotIpAddress": {
                    "aws:SourceIp": [
                        "50.31.252.0/24"
                    ]
                }
            }
        }
    ]
}' > policy_s3.json

aws s3api create-bucket --bucket andriiitsteplab1 --region us-east-1 \
  && aws s3api put-bucket-policy --bucket andriiitsteplab1 --policy file://policy_s3.json \
  && aws s3 sync ./ s3://andriiitsteplab1/ \
  && aws s3 website s3://andriiitsteplab1/ --index-document index.html --error-document error.html