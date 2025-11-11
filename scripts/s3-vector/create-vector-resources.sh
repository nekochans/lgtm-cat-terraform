#!/bin/bash
set -euo pipefail

# Usage: ./create-vector-resources.sh <stg|prod>
AWS_PROFILE="${AWS_PROFILE:-lgtm-cat}"
AWS_REGION="us-east-1"

ENVIRONMENT="${1:-}"

if [[ "$ENVIRONMENT" != "stg" && "$ENVIRONMENT" != "prod" ]]; then
    echo "Usage: $0 <stg|prod>"
    exit 1
fi

# 環境ごとの設定
if [[ "$ENVIRONMENT" == "stg" ]]; then
    VECTOR_BUCKET="stg-lgtm-cat-vectors"
    INDEX_NAME="stg-multimodal-search-index"
elif [[ "$ENVIRONMENT" == "prod" ]]; then
    VECTOR_BUCKET="prod-lgtm-cat-vectors"
    INDEX_NAME="prod-multimodal-search-index"
fi

log_info() {
    echo -e "[INFO] $1"
}

# Vector Bucket作成
log_info "Creating Vector Bucket: $VECTOR_BUCKET"
aws s3vectors create-vector-bucket \
    --vector-bucket-name "$VECTOR_BUCKET" \
    --profile "$AWS_PROFILE" \
    --region "$AWS_REGION"
log_info "Vector Bucket created: $VECTOR_BUCKET"

# Index作成
log_info "Creating Vector Index: $INDEX_NAME"
aws s3vectors create-index \
    --vector-bucket-name "$VECTOR_BUCKET" \
    --index-name "$INDEX_NAME" \
    --data-type float32 \
    --dimension 1536 \
    --distance-metric cosine \
    --profile "$AWS_PROFILE" \
    --region "$AWS_REGION"
log_info "Vector Index created: $INDEX_NAME"

log_info "All resources created successfully for environment: $ENVIRONMENT"
