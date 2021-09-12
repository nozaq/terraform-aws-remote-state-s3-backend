<a name="unreleased"></a>
## [Unreleased]


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

[Unreleased]: https://github.com/nozaq/terraform-aws-remote-state-s3-backend/compare/0.6.0...HEAD
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
