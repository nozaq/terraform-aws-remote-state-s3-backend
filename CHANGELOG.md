<a name="unreleased"></a>
## [Unreleased]


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

[Unreleased]: https://github.com/nozaq/terraform-aws-secure-baseline/compare/0.2.1...HEAD
[0.2.1]: https://github.com/nozaq/terraform-aws-secure-baseline/compare/0.2.0...0.2.1
[0.2.0]: https://github.com/nozaq/terraform-aws-secure-baseline/compare/0.1.0...0.2.0
[0.1.0]: https://github.com/nozaq/terraform-aws-secure-baseline/compare/0.0.4...0.1.0
[0.0.4]: https://github.com/nozaq/terraform-aws-secure-baseline/compare/0.0.3...0.0.4
[0.0.3]: https://github.com/nozaq/terraform-aws-secure-baseline/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/nozaq/terraform-aws-secure-baseline/compare/0.0.1...0.0.2
