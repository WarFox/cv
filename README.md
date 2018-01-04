# CV #

[![wercker status](https://app.wercker.com/status/5cbca23251a180f02e8b4b8d2d3c8179/s/master "wercker status")](https://app.wercker.com/project/bykey/5cbca23251a180f02e8b4b8d2d3c8179)

# Pandoc CV generation

This is inspired by https://github.com/barraq/pandoc-moderncv

But a very stripped down version of it, so not as beautiful as the original.

## Usage

```
make html
```

# Requirements

## Packages

- make
- pandoc - 1.19.2.1
- s3cmd - 1.6.1-1

## Environment Variables

Set the following environment variables before you run `wercker deploy`

- AWS_BUCKET_URL
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_REGION
- S3CMD_VERSION
