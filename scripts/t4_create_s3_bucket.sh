#!/usr/bin/env bash
set -euo pipefail

ENDPOINT_URL="${ENDPOINT_URL:-http://localhost:4566}"
AWS_REGION="${AWS_REGION:-us-east-1}"
BUCKET_NAME="coupons"

aws --endpoint-url "${ENDPOINT_URL}" \
    --region "${AWS_REGION}" \
    s3api create-bucket \
    --bucket "${BUCKET_NAME}" \
    --acl private
