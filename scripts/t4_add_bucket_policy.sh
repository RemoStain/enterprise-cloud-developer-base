#!/usr/bin/env bash
set -euo pipefail

ENDPOINT_URL="${ENDPOINT_URL:-http://localhost:4566}"
AWS_REGION="${AWS_REGION:-us-east-1}"
BUCKET_NAME="coupons"

POLICY_FILE="./bucket_policy.json"

cat > "${POLICY_FILE}" <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyDeleteWithoutMFA",
      "Effect": "Deny",
      "Principal": "*",
      "Action": [
        "s3:DeleteObject",
        "s3:DeleteObjectVersion"
      ],
      "Resource": "arn:aws:s3:::${BUCKET_NAME}/*",
      "Condition": {
        "Bool": {
          "aws:MultiFactorAuthPresent": "false"
        }
      }
    }
  ]
}
EOF

aws --endpoint-url "${ENDPOINT_URL}" \
    --region "${AWS_REGION}" \
    s3api put-bucket-policy \
    --bucket "${BUCKET_NAME}" \
    --policy "file://${POLICY_FILE}"
