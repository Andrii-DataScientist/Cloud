#!/bin/bash
aws s3api create-bucket --bucket andrii-lab8 --region us-east-1
aws s3api create-bucket --bucket andrii-lab8-resized --region us-east-1
aws s3api create-bucket --bucket aws-sam-cli-managed-default-samclisourcebucket-i6xlmm7wfrs9 --region us-east-1
aws s3api put-object --bucket andrii-lab8 --key tmp/logo.jpg --body logo.jpg
aws iam create-policy --policy-name AWSLambdaS3Policy --policy-document file://s3_policy.json
aws iam create-role --role-name lambda-s3-role --assume-role-policy-document file://trust-policy.json
sam build --use-container
sam deploy --guided
FUNC_NAME=$(aws lambda list-functions --query 'Functions[0].FunctionName' --output text)
aws lambda update-function-configuration --function-name $FUNC_NAME --timeout 90
aws lambda invoke --function-name $FUNC_NAME --cli-binary-format raw-in-base64-out --invocation-type Event --payload file://inputFile.txt outputfile.txt
aws lambda add-permission --function-name $FUNC_NAME --principal s3.amazonaws.com --statement-id s3invoke --action lambda:InvokeFunction --source-arn arn:aws:s3:::andrii-lab8 --source-account 577299593433
aws lambda get-policy --function-name $FUNC_NAME
FUNC_ARN=$(aws lambda list-functions --query 'Functions[0].FunctionArn' --output text)
echo '{
    "LambdaFunctionConfigurations": [
        {
            "Id": "lambda-trigger",
            "LambdaFunctionArn": "'"$FUNC_ARN"'" ,
            "Events": [
                "s3:ObjectCreated:*"
            ]
        }
    ]
}' > notification.json
aws s3api put-bucket-notification-configuration --bucket andrii-lab8 --notification-configuration file://notification.json