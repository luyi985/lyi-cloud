BUCKET_NAME="lyi-bucket"
TEMP_URL="http://${BUCKET_NAME}.s3.amazonaws.com/template/template.json"

create_temp_s3() {
    aws s3api create-bucket \
    --acl private \
    --bucket ${BUCKET_NAME} \
    --create-bucket-configuration LocationConstraint=ap-southeast-2
}

delete_temp_s3() {
    aws s3 rb s3://${BUCKET_NAME} \
    --force
}

sync_folder() {
    aws s3 sync ./files s3://${BUCKET_NAME}/files \
    --delete \
    --acl public-read && \
    aws s3 sync ./cf s3://${BUCKET_NAME}/cf \
    --delete \
    --acl public-read
}