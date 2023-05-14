#!/bin/bash

ROLE=lambda-basic-execute-and-log
source common.sh

aws iam create-role --role-name $ROLE --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Principal": {
            "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    }]
}' > create-role.log
assert_success $? "IAM create-role for $ROLE"

aws iam attach-role-policy --role-name $ROLE --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
assert_success $? "IAM attach-role-policy for $ROLE"

ARN=$(cat create-role.log | grep Arn test.txt | cut -d '"' -f4)
echo $ARN > role.arn