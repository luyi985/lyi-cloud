#! /bin/bash
aws cloudformation deploy\
 --template-file ./template.json\
 --stack-name stack-lyi\
 --s3-bucket stack-lyi\
 --parameter-overrides kn=lyi-keypair