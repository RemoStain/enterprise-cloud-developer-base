#!/usr/bin/env bash
set -euo pipefail

ENDPOINT_URL="${ENDPOINT_URL:-http://localhost:4566}"
AWS_REGION="${AWS_REGION:-us-east-1}"
LAMBDA_NAME="coupons_import_presigned_url"
ARTIFACTS_DIR="artifacts"
ZIP_FILE="${ARTIFACTS_DIR}/${LAMBDA_NAME}.zip"

mkdir -p "${ARTIFACTS_DIR}"

powershell -Command "Compress-Archive -Path lambda/${LAMBDA_NAME}/index.js -DestinationPath ${ZIP_FILE} -Force"

aws --endpoint-url "${ENDPOINT_URL}" \
    --region "${AWS_REGION}" \
    lambda update-function-code \
    --function-name "${LAMBDA_NAME}" \
    --zip-file "fileb://${ZIP_FILE}"
