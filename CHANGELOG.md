# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.5.0](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/v1.4.0...v1.5.0) (2023-04-28)


### Features

* enable ACLs for new S3 buckets after AWS changed defaults ([#111](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/111)) ([42f63c6](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/42f63c6d76ecff16b94eef07c36902b292243c98))


### Bug Fixes

* crash when replication is disabled ([#113](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/113)) ([30a9e9f](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/30a9e9f278936d601c69e95fd78d48182e8fd8bf))

## [1.4.0](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/v1.3.3...v1.4.0) (2022-10-22)


### Features

* validate bucket names ([#102](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/102)) ([f35f913](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/f35f9138ba7345da04e617ef5f3229bc2a18b3a0))

## [1.3.3](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/v1.3.2...v1.3.3) (2022-07-23)


### Bug Fixes

* kms_key_alias output ([#97](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/97)) ([abc5dc9](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/abc5dc91d947fb20b5759fc06fdad27b8f3327ef))

## [1.3.2](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/v1.3.1...v1.3.2) (2022-07-09)


### Bug Fixes

* only enable Stream when replication is enabled ([#95](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/95)) ([7b1aafc](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/7b1aafc3381ee92664cf9ab2e6388bc5b2bc53fa))

## [1.3.1](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/v1.3.0...v1.3.1) (2022-07-09)


### Bug Fixes

* disable Stream for DynamoDB ([#93](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/93)) ([704fb97](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/704fb9713f447535ae88a16c6948eddc6aac6f70))

## [1.3.0](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/v1.2.0...v1.3.0) (2022-07-09)


### Features

* added the capability to specify an alias for the KMS Key ([#87](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/87)) ([fc70af4](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/fc70af4572c686045c95936e0a1152d089fe749b))
* allow replication for DDB ([#91](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/91)) ([e63200a](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/e63200a17c78a109c89f81e16eb9566b7aef2009))
* optionally set the IAM policy boundary ([#90](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/90)) ([bfb3701](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/bfb3701fe1c222b82c77f6e60eb0903105e5b081))


### Bug Fixes

* replace output to be either null or the actual value. ([#92](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/92)) ([a8141fd](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/a8141fd78214154dd2480b194d4efab11a233a7c))

## [1.2.0](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/v1.1.2...v1.2.0) (2022-04-16)


### Features

* use S3 replication rule V2 ([#85](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/85)) ([26e8493](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/26e84939279e277493ca7f0ef087a7be1565312e))

## [1.1.2](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/v1.1.1...v1.1.2) (2022-03-16)
### Bug Fixes
- updated policy to fix syntax issue ([#80](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/80)) ([bb5e8d9](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/bb5e8d9ca9e8b9993cc7143d6ae8ee963f15f053))

## [1.1.1](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/v1.1.0...v1.1.1) (2022-03-15)
### Bug Fixes
- add permissions required by terragrunt ([#75](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/75)) ([93f327c](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/93f327ca936bc09d0694145a2374b695256b373b))

## [1.1.0](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/v1.0.1...v1.1.0) (2022-03-08)
### Features
- enable server side encryption for DynamoDB table ([c1c9262](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/c1c9262064c25d9437a97e7ea8793a4250ee6708))

## 1.0.1 - 2022-03-05
### Fix
- replication depends on versioning ([#61](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/61))

## 1.0.0 - 2022-02-12
### Feat
- upgrade AWS provider to v4.0+ ([#57](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/57))

### Fix
- set the minimum terraform version to 1.1.4 ([#56](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/56))

### BREAKING CHANGE
resources regarding S3 bucket configurations need manual
imports after upgrade. See `docs/upgrade-1.0.md` for guidance.

## 0.8.1 - 2022-01-10

## 0.8.0 - 2022-01-10
### Refactor
- add tflint checks
- simplify list item extractions ([#48](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/48))
- do not hard-code auth method in examples ([#46](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/46))

## 0.7.0 - 2021-10-10
### Feat
- support to create fixed bucket name ([#43](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/43))
- make s3 bucket replication optional ([#42](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/42))
- support logging for state Bucket ([#37](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/37))

### Fix
- make the fixed bucket name optional ([#44](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/44))

## 0.6.0 - 2021-06-27
### Fix
- conflicting operations on S3 buckets ([#33](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/33))

### Refactor
- add `required_providers` configuration ([#39](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/39))

## 0.5.0 - 2021-06-06
### Feat
- enable point-in-time recovery for DynamoDB table

## 0.4.1 - 2020-11-14
### Fix
- interporation warnings

## 0.4.0 - 2020-09-21

## 0.3.1 - 2020-08-10
### Fix
- make terraform_iam_policy to be a string ([#25](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/25))

## 0.3.0 - 2020-08-10
### Fix
- remove region attribute ([#24](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/24))

## 0.2.1 - 2019-08-18
### Fix
- allow use of KMS keys by the replication role
- encrypt state files in the replica bucket

## 0.2.0 - 2019-08-11
### Feat
- add noncurrent_version_expiration option
- add s3_bucket_force_destroy flag
- move non-current versions to Glacier

### Fix
- insufficient persmission to encrypt states with the KMS key

## 0.1.0 - 2019-08-10
### Feat
- add "tags" input variable

## 0.0.4 - 2019-07-14
### Fix
- use a provider for replica bucket

## 0.0.3 - 2019-07-14
### Feat
- enable public access block for S3 buckets

## 0.0.2 - 2019-07-14
### Feat
- derive a region for replica bucket from the provider
