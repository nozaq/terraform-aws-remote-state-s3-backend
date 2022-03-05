<a name="unreleased"></a>
## 0.1.0 (2022-03-05)


### ⚠ BREAKING CHANGES

* resources regarding S3 bucket configurations need manual imports after upgrade. See `docs/upgrade-1.0.md` for guidance.

### Features

* add "tags" input variable ([6c7ddc0](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/6c7ddc0d6c1a993f06c0d8436e0127ad15b7eb36))
* add noncurrent_version_expiration option ([42c4457](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/42c4457b42833be9a88ae659da9835daf646a229))
* add s3_bucket_force_destroy flag ([1a58821](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/1a588212316b3baab30b3caa069ced4e6701be52))
* derive a region for replica bucket from the provider ([7fc00eb](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/7fc00eb0622a01cdde26bd68e8acec8fb5edcfb9))
* enable point-in-time recovery for DynamoDB table ([02ce75f](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/02ce75f60cb6728d49b6c0cbb9fccfee33d4e16a))
* enable public access block for S3 buckets ([1eef6c4](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/1eef6c45ad7473946f0b88d22fe445bea9f395ae))
* make s3 bucket replication optional ([#42](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/42)) ([7691afd](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/7691afda08e9935f83fcfb3244b02675b63ce99a))
* move non-current versions to Glacier ([e7a5e53](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/e7a5e53af8c81e0c70196f8b4e407f1101c21040))
* support logging for state Bucket ([#37](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/37)) ([f26b823](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/f26b82392fbde2e1fb334c6e84b66121b012c681))
* support to create fixed bucket name ([#43](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/43)) ([25b6d8c](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/25b6d8ce49b892f10a23f26f3563964c194db041))
* upgrade AWS provider to v4.0+ ([#57](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/57)) ([271204c](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/271204cd8260a46531eab96056239d46e4e3b7c8))


### Bug Fixes

* allow use of KMS keys by the replication role ([8b20987](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/8b20987cdc1fc4b1086e0f95a089b983b383b6af))
* conflicting operations on S3 buckets ([#33](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/33)) ([9210c32](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/9210c324f3c6881785484437e560bd7028a3690a))
* encrypt state files in the replica bucket ([f56dd14](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/f56dd144c035bd7716da950ffb293ca6ddb91395))
* insufficient persmission to encrypt states with the KMS key ([f31090d](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/f31090da0c4da30b9a3bc0cbe9dad604df1f1911))
* interporation warnings ([e389eae](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/e389eae9ece8df0286b65e20f75e6c130a94f221))
* make terraform_iam_policy to be a string ([#25](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/25)) ([7290218](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/7290218e4cb2c702e9c095178239dce6bbb2f185))
* make the fixed bucket name optional ([#44](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/44)) ([beb2f64](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/beb2f6433c956b1a6232c9b85f45f6d97f7ac99e))
* remove region attribute ([#24](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/24)) ([52b04a3](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/52b04a3c070e7d76b045baf1bb88c1844c8066d9))
* replication depends on versioning ([#61](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/61)) ([a830edd](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/a830eddf8daf19ca55af72b7ed69431c822e1e1a))
* set the minimum terraform version to 1.1.4 ([#56](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/56)) ([642ccbf](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/642ccbfdb1710a12349af743b3a2e9ded8eceb1b))
* use a provider for replica bucket ([071c572](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/commit/071c572d3a66d7a704501fe18a8918b44dd5026c))

## [Unreleased]


<a name="1.0.1"></a>
## [1.0.1] - 2022-03-05
### Fix
- replication depends on versioning ([#61](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/61))


<a name="1.0.0"></a>
## [1.0.0] - 2022-02-12
### Feat
- upgrade AWS provider to v4.0+ ([#57](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/57))

### Fix
- set the minimum terraform version to 1.1.4 ([#56](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/56))

### BREAKING CHANGE

resources regarding S3 bucket configurations need manual
imports after upgrade. See `docs/upgrade-1.0.md` for guidance.


<a name="0.8.1"></a>
## [0.8.1] - 2022-01-10

<a name="0.8.0"></a>
## [0.8.0] - 2022-01-10
### Refactor
- add tflint checks
- simplify list item extractions ([#48](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/48))
- do not hard-code auth method in examples ([#46](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/46))


<a name="0.7.0"></a>
## [0.7.0] - 2021-10-10
### Feat
- support to create fixed bucket name ([#43](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/43))
- make s3 bucket replication optional ([#42](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/42))
- support logging for state Bucket ([#37](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/37))

### Fix
- make the fixed bucket name optional ([#44](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/44))


<a name="0.6.0"></a>
## [0.6.0] - 2021-06-27
### Fix
- conflicting operations on S3 buckets ([#33](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/33))

### Refactor
- add `required_providers` configuration ([#39](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/39))


<a name="0.5.0"></a>
## [0.5.0] - 2021-06-06
### Feat
- enable point-in-time recovery for DynamoDB table


<a name="0.4.1"></a>
## [0.4.1] - 2020-11-14
### Fix
- interporation warnings


<a name="0.4.0"></a>
## [0.4.0] - 2020-09-21

<a name="0.3.1"></a>
## [0.3.1] - 2020-08-10
### Fix
- make terraform_iam_policy to be a string ([#25](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/25))


<a name="0.3.0"></a>
## [0.3.0] - 2020-08-10
### Fix
- remove region attribute ([#24](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/24))


<a name="0.2.1"></a>
## [0.2.1] - 2019-08-18
### Fix
- allow use of KMS keys by the replication role
- encrypt state files in the replica bucket


<a name="0.2.0"></a>
## [0.2.0] - 2019-08-11
### Feat
- add noncurrent_version_expiration option
- add s3_bucket_force_destroy flag
- move non-current versions to Glacier

### Fix
- insufficient persmission to encrypt states with the KMS key


<a name="0.1.0"></a>
## [0.1.0] - 2019-08-10
### Feat
- add "tags" input variable


<a name="0.0.4"></a>
## [0.0.4] - 2019-07-14
### Fix
- use a provider for replica bucket


<a name="0.0.3"></a>
## [0.0.3] - 2019-07-14
### Feat
- enable public access block for S3 buckets


<a name="0.0.2"></a>
## [0.0.2] - 2019-07-14
### Feat
- derive a region for replica bucket from the provider


<a name="0.0.1"></a>
## 0.0.1 - 2019-07-14

[Unreleased]: https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/1.0.1...HEAD
[1.0.1]: https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/0.8.1...1.0.0
[0.8.1]: https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/0.8.0...0.8.1
[0.8.0]: https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/0.7.0...0.8.0
[0.7.0]: https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/0.6.0...0.7.0
[0.6.0]: https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/0.5.0...0.6.0
[0.5.0]: https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/0.4.1...0.5.0
[0.4.1]: https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/0.4.0...0.4.1
[0.4.0]: https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/0.3.1...0.4.0
[0.3.1]: https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/0.3.0...0.3.1
[0.3.0]: https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/0.2.1...0.3.0
[0.2.1]: https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/0.2.0...0.2.1
[0.2.0]: https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/0.1.0...0.2.0
[0.1.0]: https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/0.0.4...0.1.0
[0.0.4]: https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/0.0.3...0.0.4
[0.0.3]: https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/0.0.1...0.0.2
