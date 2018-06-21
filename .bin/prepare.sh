#!/bin/bash

aws s3api create-bucket \
    --acl private \
    --bucket lyi-bucket \
    --create-bucket-configuration LocationConstraint=ap-southeast-2