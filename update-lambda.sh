#!/bin/bash

source common.sh

if [ "$1" == "" ]; then
  echo "Usage: update-lambda.sh NAME"
  exit 1
fi

if [ -e "$1" ]; then
  echo "Updating $1"
else
  echo "$1 does not exist"
  exit 2
fi

cd $1
zip -r ../$1.zip .
cd ..
aws lambda update-function --function-name $1 \
--zip-file fileb://$1.zip