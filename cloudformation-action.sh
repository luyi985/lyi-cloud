#!/bin/sh
s3Region="ap-southeast-2"
bucketName="stack-lyi"
templateFile="template.json"

alias createBucket="aws s3api create-bucket \
    --bucket ${bucketName} \
    --region ${s3Region} \
    --create-bucket-configuration LocationConstraint=${s3Region}"

alias s3Upload="aws s3 cp ${templateFile} s3://${bucketName} --acl public-read"
alias cf-update="s3Upload && \
            export tempUrl=\"https://s3-${s3Region}.amazonaws.com/${bucketName}/${templateFile}\" && \
            curl ${tempUrl}"