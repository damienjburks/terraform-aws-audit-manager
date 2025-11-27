# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.2] - 2024-11-26

### Fixed
- Fixed IAM module count argument error by adding `create_bucket_policy` variable
- Resolved Terraform plan-time dependency issue where count depended on computed S3 module outputs

## [0.1.1] - 2024-11-26

### Changed
- Refactored module structure into sub-modules for better organization
  - Created `modules/s3` for evidence bucket resources
  - Created `modules/kms` for encryption key resources
  - Created `modules/iam` for IAM roles and policies
  - Created `modules/assessments` for assessment resources
- Moved documentation files to `docs/` directory
- Improved module maintainability and testability

### Added
- CODE_OF_CONDUCT.md for community guidelines
- CONTRIBUTING.md with detailed contribution guidelines
- Helper script `scripts/list-frameworks.sh` to find framework UUIDs
- Comprehensive documentation on finding framework UUIDs

### Fixed
- Framework ID validation - clarified that UUIDs (not ARNs) are required
- Assessment reports destination now properly defaults to evidence bucket
- Updated all examples to use framework UUID placeholders

## [0.1.0] - 2024-11-26

### Added
- Initial stable release of terraform-aws-audit-manager module
- Support for enabling AWS Audit Manager in single AWS accounts
- Support for organization-wide Audit Manager with delegated administrator
- Automatic S3 bucket creation for evidence storage with encryption
- Optional custom KMS key support for evidence encryption
- Configurable evidence retention with S3 lifecycle policies
- Assessment creation from standard and custom frameworks
- Support for multiple assessments with flexible scope configuration
- IAM role and policy management for Audit Manager service
- Comprehensive input validation for regions, bucket names, and account IDs
- Tag propagation to all created resources
- Three complete examples:
  - Single account deployment
  - Organization-wide deployment
  - Custom framework configuration
- Complete documentation with usage examples
- Terraform Registry standard module structure
- Support for AWS provider >= 4.0.0 and Terraform >= 1.0.0

### Security
- S3 buckets created with KMS encryption by default
- Public access blocked on all evidence buckets
- Bucket versioning enabled for evidence integrity
- IAM policies following principle of least privilege
- S3 access logging enabled

[Unreleased]: https://github.com/damienjburks/terraform-aws-audit-manager/compare/v0.1.2...HEAD
[0.1.2]: https://github.com/damienjburks/terraform-aws-audit-manager/releases/tag/v0.1.2
[0.1.1]: https://github.com/damienjburks/terraform-aws-audit-manager/releases/tag/v0.1.1
[0.1.0]: https://github.com/damienjburks/terraform-aws-audit-manager/releases/tag/v0.1.0
