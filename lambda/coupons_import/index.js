'use strict';

const AWS = require('aws-sdk');

const BUCKET_NAME = process.env.COUPONS_BUCKET || 'coupons';

// In localstack deployments we often need path-style access
const s3Config = {};
if (process.env.S3_ENDPOINT_URL) {
  s3Config.endpoint = process.env.S3_ENDPOINT_URL;
  s3Config.s3ForcePathStyle = true;
}

const s3 = new AWS.S3(s3Config);

exports.handler = async (event) => {
  try {
    const body = typeof event.body === 'string'
      ? JSON.parse(event.body || '{}')
      : (event.body || {});

    const couponId = body.coupon_id;
    if (!couponId) {
      return {
        statusCode: 400,
        body: JSON.stringify({ status: 'error', message: 'coupon_id is required' })
      };
    }

    const key = `${couponId}.json`;

    await s3.putObject({
      Bucket: BUCKET_NAME,
      Key: key,
      Body: JSON.stringify(body),
      ContentType: 'application/json'
    }).promise();

    return {
      statusCode: 200,
      body: JSON.stringify({ status: 'success' })
    };
  } catch (err) {
    console.error('Error in coupons_import:', err);
    return {
      statusCode: 500,
      body: JSON.stringify({ status: 'error', message: 'internal error' })
    };
  }
};
