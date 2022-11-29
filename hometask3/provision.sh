#!/bin/bash

aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pem \
&& chmod 400 MyKeyPair.pem \
&& VPC_ID=$(aws ec2 describe-vpcs --query 'Vpcs[0].VpcId' --output text) \
&& aws ec2 create-security-group --group-name SecurityGroup --description "My security group" \
&& SG=$(aws ec2 describe-security-groups --query 'SecurityGroups[0].GroupId' --output text) \
&& aws ec2 authorize-security-group-ingress --group-id $SG --protocol tcp --port 22 --cidr 0.0.0.0/0 \
&& aws ec2 authorize-security-group-ingress --group-id $SG  --protocol tcp --port 80 --cidr 0.0.0.0/0 \
&& aws ec2 authorize-security-group-ingress --group-id $SG  --protocol tcp --port 443 --cidr 0.0.0.0/0 \
&& touch user_script.sh \
&& echo '#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd' > user_script.sh \
&& NET_ID=$(aws ec2 describe-subnets --query 'Subnets[0].SubnetId' --output text) \
&& aws ec2 run-instances --image-id ami-0b0dcb5067f052a63 --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids $SG --user-data file://user_script.sh \
&& INST_ID=$(aws ec2 describe-instances --instance-ids --query 'Reservations[0].Instances[0].InstanceId' --output text) \
&& aws ec2 create-tags --resources $INST_ID --tags Key=Name,Value=ApacheInstance \
&& echo $INST_ID