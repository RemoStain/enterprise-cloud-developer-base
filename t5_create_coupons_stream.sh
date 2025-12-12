awslocal kinesis create-stream \
  --stream-name coupons \
  --shard-count 5

awslocal kinesis wait stream-exists \
  --stream-name coupons
