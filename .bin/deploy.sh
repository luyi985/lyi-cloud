#! /bin/bash
BUCKET="lyi-bucket"
STACK="lyi-stack"

aws s3 sync ./cf s3://${BUCKET}/cf \
    --delete \
    --acl public-read && \
aws cloudformation deploy\
 --template-file ./cf/template.json\
 --stack-name ${STACK} \
 --s3-bucket ${BUCKET} \
 --capabilities CAPABILITY_NAMED_IAM