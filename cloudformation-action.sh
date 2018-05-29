#!/bin/sh
s3Region="ap-southeast-2"
bucketName="stack-lyi"
templateFile="template.json"

tempUrl="https://s3-${s3Region}.amazonaws.com/${bucketName}/${templateFile}"

alias createBucket="aws s3api create-bucket \
    --bucket ${bucketName} \
    --region ${s3Region} \
    --create-bucket-configuration LocationConstraint=${s3Region}"

alias s3Upload="aws s3 cp ${templateFile} s3://${bucketName} --acl public-read"
alias cf-update="s3Upload && curl ${tempUrl}"

alias cf-create="aws cloudformation deploy --template-file ./${templateFile} --stack-name ${bucketName}"
#alias cf-push="cf-update && aws cloudformation update-stack --template-url ${tempUrl} --stack-name ${bucketName} && echo \"Success!\""



alias cf-push="cf-update && \
               aws cloudformation update-stack \
               --template-url ${tempUrl} \
               --stack-name ${bucketName} \
               --parameters --parameters ParameterKey=KeyPairName,ParameterValue=lyi-keypair"


