#! /bin/bash
BUCKET="lyi-bucket"
STACK="lyi-stack"

aws s3 sync ./cf s3://${BUCKET}/cf \
    --delete \
    --acl public-read && \
aws cloudformation update-stack \
 --stack-name ${STACK} \
 --template-url https://s3-ap-southeast-2.amazonaws.com/lyi-bucket/cf/template.json \
 --capabilities CAPABILITY_NAMED_IAM