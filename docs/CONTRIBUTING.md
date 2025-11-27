# Contributing Guide

Thank you for your interest in contributing to the terraform-aws-audit-manager module! We welcome contributions from the community.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Guidelines](#development-guidelines)
- [Submitting Changes](#submitting-changes)
- [Reporting Bugs](#reporting-bugs)
- [Requesting Features](#requesting-features)

## Code of Conduct

This project adheres to a [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to damien@damienjburks.com.

## Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- An AWS account with permissions to create Audit Manager resources
- Git for version control

### Setting Up Your Development Environment

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/terraform-aws-audit-manager.git
   cd terraform-aws-audit-manager
   ```

3. Add the upstream repository:
   ```bash
   git remote add upstream https://github.com/damienjburks/terraform-aws-audit-manager.git
   ```

4. Create a branch for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## How to Contribute

### Types of Contributions

We welcome various types of contributions:

- **Bug fixes**: Fix issues in existing functionality
- **New features**: Add new capabilities to the module
- **Documentation**: Improve or add documentation
- **Examples**: Add new usage examples
- **Tests**: Add or improve tests
- **Code quality**: Refactoring, optimization, or cleanup

## Development Guidelines

### Code Style

- Follow [Terraform style conventions](https://www.terraform.io/docs/language/syntax/style.html)
- Use `terraform fmt` to format all `.tf` files
- Use meaningful variable and resource names
- Add comments for complex logic

### Module Structure

The module follows this structure:
```
terraform-aws-audit-manager/
├── modules/              # Sub-modules
│   ├── s3/              # S3 evidence bucket
│   ├── kms/             # KMS encryption
│   ├── iam/             # IAM roles and policies
│   └── assessments/     # Audit Manager assessments
├── examples/            # Usage examples
├── docs/                # Additional documentation
├── main.tf              # Main module configuration
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── versions.tf          # Provider requirements
├── locals.tf            # Local values
└── data.tf              # Data sources
```

### Testing

Before submitting changes:

1. **Format your code**:
   ```bash
   terraform fmt -recursive
   ```

2. **Validate syntax**:
   ```bash
   terraform init
   terraform validate
   ```

3. **Test examples**:
   ```bash
   cd examples/single-account
   terraform init
   terraform validate
   terraform plan
   ```

4. **Check for breaking changes**: Ensure your changes don't break existing functionality

### Documentation

- Update README.md if adding new features or changing behavior
- Add inline comments for complex logic
- Update variable descriptions in variables.tf
- Update output descriptions in outputs.tf
- Add or update examples if relevant
- Update CHANGELOG.md following [Keep a Changelog](https://keepachangelog.com/) format

### Commit Messages

Write clear, concise commit messages:

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests when relevant

Examples:
```
Add support for custom KMS keys

Fix bucket policy to allow Audit Manager access

Update README with framework UUID instructions
```

## Submitting Changes

### Pull Request Process

1. **Update your fork**:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Push your changes**:
   ```bash
   git push origin feature/your-feature-name
   ```

3. **Create a Pull Request**:
   - Go to the repository on GitHub
   - Click "New Pull Request"
   - Select your fork and branch
   - Fill out the PR template with:
     - Description of changes
     - Related issue numbers
     - Testing performed
     - Breaking changes (if any)

4. **Address review feedback**:
   - Respond to comments
   - Make requested changes
   - Push updates to your branch

5. **Merge requirements**:
   - All CI checks must pass
   - At least one maintainer approval required
   - No unresolved conversations
   - Branch must be up to date with main

### Pull Request Guidelines

- Keep PRs focused on a single feature or fix
- Include tests for new functionality
- Update documentation as needed
- Follow the existing code style
- Ensure all examples still work
- Add entries to CHANGELOG.md

## Reporting Bugs

### Before Submitting a Bug Report

- Check the [existing issues](https://github.com/damienjburks/terraform-aws-audit-manager/issues) to avoid duplicates
- Verify the bug exists in the latest version
- Collect relevant information (Terraform version, AWS provider version, error messages)

### How to Submit a Bug Report

Create an issue with the following information:

**Title**: Brief, descriptive summary

**Description**:
- Steps to reproduce
- Expected behavior
- Actual behavior
- Terraform version
- AWS provider version
- Relevant configuration snippets
- Error messages or logs

**Example**:
```markdown
## Bug Description
Assessment creation fails with validation error

## Steps to Reproduce
1. Configure module with assessment
2. Run terraform apply
3. Error occurs

## Expected Behavior
Assessment should be created successfully

## Actual Behavior
Error: validation error on framework_id

## Environment
- Terraform: v1.5.0
- AWS Provider: v5.0.0
- Region: us-east-1

## Configuration
[Include relevant .tf file snippets]

## Error Output
[Include error messages]
```

## Requesting Features

### Before Submitting a Feature Request

- Check if the feature already exists
- Review [existing feature requests](https://github.com/damienjburks/terraform-aws-audit-manager/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)
- Consider if the feature fits the module's scope

### How to Submit a Feature Request

Create an issue with:

**Title**: Clear feature description

**Description**:
- Use case and motivation
- Proposed solution
- Alternative solutions considered
- Additional context

**Example**:
```markdown
## Feature Request
Add support for cross-region evidence replication

## Use Case
Organizations with compliance requirements need evidence stored in multiple regions

## Proposed Solution
Add optional variable for replica bucket configuration

## Alternatives
Manual replication setup outside the module

## Additional Context
Similar to S3 cross-region replication feature
```

## Versioning

This project follows [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backwards compatible)
- **PATCH**: Bug fixes (backwards compatible)

See [docs/VERSIONING.md](docs/VERSIONING.md) for detailed versioning guidelines.

## Release Process

Releases are managed by maintainers:

1. Update CHANGELOG.md
2. Update version references
3. Create and push version tag
4. GitHub Actions publishes to Terraform Registry

## Questions?

- Open a [discussion](https://github.com/damienjburks/terraform-aws-audit-manager/discussions) for general questions
- Check existing [issues](https://github.com/damienjburks/terraform-aws-audit-manager/issues) and [pull requests](https://github.com/damienjburks/terraform-aws-audit-manager/pulls)
- Review the [README](README.md) and [examples](examples/)

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (see [LICENSE](LICENSE)).

---

Thank you for contributing to terraform-aws-audit-manager! 🎉
