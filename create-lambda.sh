#!/bin/bash

source common.sh

if [ "$1" == "" ]; then
  echo "Usage: create-lambda.sh NAME [PYTHON-DEPENDENCIES]"
  exit 1
fi

if [ -e role.arn ]; then
  ROLE=$(cat role.arn | head -n2)
else
  echo "Error: run create-lambda-role.sh first"
  exit 4
fi

if [ -e "$1" ]; then
  echo "$1 already exists"
  exit 2
fi

mkdir $1
cd $1
cp ../lambda-template.py lambda_function.py

python3 -m venv venv
source venv/bin/activate

SUCCESS=1
if [ "$2" != "" ]; then
  for f in $(echo $2); do
    pip3 install $f
    assert_success $? "pip3 install $f"
  done
  pip3 freeze > requirements.txt
fi

zip -r ../$1.zip .
cd ..
aws lambda create-function --function-name $1 \
--zip-file fileb://$1.zip \
--handler lambda_function.lambda_handler \
--runtime python3.7 \
--role $ROLE