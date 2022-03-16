### [1.1.2](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/v1.1.1...v1.1.2) (2022-03-16)


### Bug Fixes

* updated policy to fix syntax issue ([#80](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/80)) ([bb5e8d9](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/bb5e8d9ca9e8b9993cc7143d6ae8ee963f15f053))

### [1.1.1](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/v1.1.0...v1.1.1) (2022-03-15)


### Bug Fixes

* add permissions required by terragrunt ([#75](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/75)) ([93f327c](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/93f327ca936bc09d0694145a2374b695256b373b))

### [1.1.0](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/v1.0.1...v1.1.0) (2022-03-08)


### Features

* enable server side encryption for DynamoDB table ([c1c9262](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/c1c9262064c25d9437a97e7ea8793a4250ee6708))


### 1.0.1 - 2022-03-05
### Fix
- replication depends on versioning ([#61](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/61))


### 1.0.0 - 2022-02-12
### Feat
- upgrade AWS provider to v4.0+ ([#57](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/57))

### Fix
- set the minimum terraform version to 1.1.4 ([#56](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/56))

### BREAKING CHANGE

resources regarding S3 bucket configurations need manual
imports after upgrade. See `docs/upgrade-1.0.md` for guidance.


### 0.8.1 - 2022-01-10

### 0.8.0 - 2022-01-10
### Refactor
- add tflint checks
- simplify list item extractions ([#48](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/48))
- do not hard-code auth method in examples ([#46](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/46))


### 0.7.0 - 2021-10-10
### Feat
- support to create fixed bucket name ([#43](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/43))
- make s3 bucket replication optional ([#42](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/42))
- support logging for state Bucket ([#37](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/37))

### Fix
- make the fixed bucket name optional ([#44](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/44))


### 0.6.0 - 2021-06-27
### Fix
- conflicting operations on S3 buckets ([#33](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/33))

### Refactor
- add `required_providers` configuration ([#39](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/39))


### 0.5.0 - 2021-06-06
### Feat
- enable point-in-time recovery for DynamoDB table


### 0.4.1 - 2020-11-14
### Fix
- interporation warnings


### 0.4.0 - 2020-09-21

### 0.3.1 - 2020-08-10
### Fix
- make terraform_iam_policy to be a string ([#25](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/25))


### 0.3.0 - 2020-08-10
### Fix
- remove region attribute ([#24](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/24))


### 0.2.1 - 2019-08-18
### Fix
- allow use of KMS keys by the replication role
- encrypt state files in the replica bucket


### 0.2.0 - 2019-08-11
### Feat
- add noncurrent_version_expiration option
- add s3_bucket_force_destroy flag
- move non-current versions to Glacier

### Fix
- insufficient persmission to encrypt states with the KMS key


### 0.1.0 - 2019-08-10
### Feat
- add "tags" input variable


### 0.0.4 - 2019-07-14
### Fix
- use a provider for replica bucket


### 0.0.3 - 2019-07-14
### Feat
- enable public access block for S3 buckets


### 0.0.2 - 2019-07-14
### Feat
- derive a region for replica bucket from the provider
