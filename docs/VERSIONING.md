# Semantic Versioning Strategy

This module follows [Semantic Versioning 2.0.0](https://semver.org/) (MAJOR.MINOR.PATCH).

## Version Format: X.Y.Z

### MAJOR version (X.0.0)
Increment when making **breaking changes** that require users to modify their code:

- Removing or renaming input variables
- Removing or renaming outputs
- Changing variable types or validation rules that reject previously valid inputs
- Removing resources or changing resource behavior in incompatible ways
- Changing default values that significantly alter behavior
- Requiring new provider versions with breaking changes
- Removing support for Terraform versions

**Example:** `1.0.0` → `2.0.0`

### MINOR version (X.Y.0)
Increment when adding **backwards-compatible functionality**:

- Adding new optional input variables (with defaults)
- Adding new outputs
- Adding new optional resources
- Adding new examples
- Enhancing existing functionality without breaking changes
- Adding support for new AWS regions or frameworks
- Improving documentation significantly

**Example:** `1.2.0` → `1.3.0`

### PATCH version (X.Y.Z)
Increment when making **backwards-compatible bug fixes**:

- Fixing bugs in existing functionality
- Correcting documentation errors
- Updating dependencies (provider versions) within compatible ranges
- Performance improvements
- Security patches that don't change behavior
- Fixing validation rules that were too restrictive

**Example:** `1.2.3` → `1.2.4`

## Pre-release Versions

For testing before official releases:
- **Alpha:** `1.0.0-alpha.1` - Early testing, unstable
- **Beta:** `1.0.0-beta.1` - Feature complete, testing
- **RC:** `1.0.0-rc.1` - Release candidate, final testing

## Initial Release Strategy

### v0.x.x - Pre-1.0 Development
- `v0.1.0` - Initial working implementation
- `v0.2.0` - Add organization mode support
- `v0.3.0` - Add assessment features
- Breaking changes allowed without major version bump

### v1.0.0 - First Stable Release
Release when:
- All core features implemented and tested
- Documentation complete
- Examples validated
- API stable and ready for production use

## Version Tagging

Use Git tags for releases:
```bash
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

## Changelog

Maintain a `CHANGELOG.md` following [Keep a Changelog](https://keepachangelog.com/):
- **Added** - New features
- **Changed** - Changes in existing functionality
- **Deprecated** - Soon-to-be removed features
- **Removed** - Removed features
- **Fixed** - Bug fixes
- **Security** - Security fixes

## Terraform Registry Requirements

- Tags must follow `vX.Y.Z` format (with 'v' prefix)
- Each tag creates a new version in the registry
- Registry automatically detects and publishes tagged versions
- Minimum version: `v1.0.0` recommended for production use

## Recommended Initial Version

**Start with `v1.0.0`** since:
- Module is feature-complete
- All requirements implemented
- Examples and documentation ready
- Production-ready quality

## Version Constraints for Users

Users should pin versions in their code:

```hcl
module "audit_manager" {
  source  = "damienjburks/audit-manager/aws"
  version = "~> 1.0"  # Allow MINOR and PATCH updates
  
  # or for stricter control
  version = "1.0.0"   # Pin to exact version
}
```

## Breaking Change Examples

### ❌ Breaking (MAJOR bump required)
```hcl
# Renaming a variable
- variable "bucket_name" {}
+ variable "evidence_bucket_name" {}

# Changing variable type
- variable "retention_days" { type = number }
+ variable "retention_days" { type = string }

# Removing an output
- output "bucket_id" {}
```

### ✅ Non-breaking (MINOR bump)
```hcl
# Adding optional variable with default
+ variable "enable_logging" {
+   type    = bool
+   default = true
+ }

# Adding new output
+ output "kms_key_arn" {
+   value = aws_kms_key.evidence.arn
+ }
```

## Version History Tracking

Document all changes in `CHANGELOG.md`:

```markdown
## [1.1.0] - 2024-01-15
### Added
- Support for custom KMS keys
- New output for KMS key ARN

## [1.0.1] - 2024-01-10
### Fixed
- Bucket policy syntax error
- Documentation typo

## [1.0.0] - 2024-01-05
### Added
- Initial stable release
- Single account support
- Organization mode support
- Assessment creation
```

## Communication

For MAJOR version changes:
- Provide migration guide
- Document all breaking changes
- Give advance notice if possible
- Consider deprecation warnings in previous MINOR versions
