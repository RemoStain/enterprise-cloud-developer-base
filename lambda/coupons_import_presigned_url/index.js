'use strict';

const AWS = require('aws-sdk');

const BUCKET_NAME = process.env.COUPONS_BUCKET || 'coupons';

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

    const filename = body.filename;
    if (!filename) {
      return {
        statusCode: 400,
        body: JSON.stringify({ status: 'error', message: 'filename is required' })
      };
    }

    const params = {
      Bucket: BUCKET_NAME,
      Key: filename,
      Expires: 300, // 5 minutes
      ContentType: 'application/json'
    };

    const uploadUrl = await s3.getSignedUrlPromise('putObject', params);

    return {
      statusCode: 200,
      body: JSON.stringify({
        status: 'success',
        upload_url: uploadUrl,
        filename: filename
      })
    };
  } catch (err) {
    console.error('Error in coupons_import_presigned_url:', err);
    return {
      statusCode: 500,
      body: JSON.stringify({ status: 'error', message: 'internal error' })
    };
  }
};
