TOPIC_ARN="$(awslocal sns list-topics --query "Topics[?ends_with(TopicArn, ':coupons')].TopicArn | [0]" --output text)"

cat > /tmp/coupons-topic-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyNonEmailSubscriptions",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "sns:Subscribe",
      "Resource": "$TOPIC_ARN",
      "Condition": {
        "StringNotEquals": {
          "sns:Protocol": "email"
        }
      }
    }
  ]
}
EOF

awslocal sns set-topic-attributes \
  --topic-arn "$TOPIC_ARN" \
  --attribute-name Policy \
  --attribute-value file:///tmp/coupons-topic-policy.json
