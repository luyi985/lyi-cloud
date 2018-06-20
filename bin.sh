BUCKET_NAME="lyi-us-bucket"
FILES_PREFIX="/input"
CF_PREFIX="/cf"
REGION="us-west-2"
S3_URL="http://${BUCKET_NAME}.s3.amazonaws.com"
echo "http://${BUCKET_NAME}.s3.amazonaws.com/"

LAMDA_NAME="lyi-lambda-func"

create_s3() {
    aws s3api create-bucket \
    --acl private \
    --bucket ${BUCKET_NAME} \
    --create-bucket-configuration LocationConstraint=${REGION} \
    --profile lyi-us && \
    mkdir ./files
}

delete_s3() {
    aws s3 rb s3://${BUCKET_NAME} \
    --force
}

sync_folder() {
    aws s3 sync ./files s3://${BUCKET_NAME}${FILES_PREFIX} \
    --delete \
    --acl public-read && \
    echo "${S3_URL}${FILES_PREFIX}" && \
    aws s3 sync ./cf s3://${BUCKET_NAME}${CF_PREFIX} \
    --delete \
    --acl public-read \
    --profile lyi-us && \
    echo "${S3_URL}${CF_PREFIX}"
}

prepare_lambda() {
    echo "Prepare lambda..."
    [[ -f ./files/lyi-lambda-func.zip ]] && rm ./lyi-lambda-func.zip
    zip -r ./files/lyi-lambda-func.zip ./lyi-lambda-func/ && \
    aws s3 sync ./files s3://${BUCKET_NAME}${FILES_PREFIX} \
    --delete \
    --acl public-read 
    --profile lyi-us && \
    echo "${S3_URL}${FILES_PREFIX}"
}

create_lambda() {
    echo "Deploy lambda..."
    prepare_lambda && \
    aws lambda create-function \
    --function-name ${LAMDA_NAME} \
    --runtime nodejs8.10 \
    --role arn:aws:iam::331159120815:role/lambda-play \
    --handler "${LAMDA_NAME}.handler" \
    --code S3Bucket=${BUCKET_NAME},S3Key="files/${LAMDA_NAME}.zip"
}

update_lambda() {
    echo "Update lambda..."
    prepare_lambda && \
    aws lambda update-function-code \
    --function-name ${LAMDA_NAME} \
    --s3-bucket ${BUCKET_NAME} \
    --s3-key "files/${LAMDA_NAME}.zip"
}

delete_lambda() {
    echo "Delete lambda..."
    aws lambda delete-function \
    --function-name ${LAMDA_NAME}
}

create_comprehend() {
    sync_folder && aws comprehend start-topics-detection-job \
                --number-of-topics 10 \
                --job-name "lyi-comprehend" \
                --region ${REGION} \
                --cli-input-json file://$(pwd)/input-json.json \
                --profile lyi-us
}