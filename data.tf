# Data source definitions

################################################################################
# AWS Account and Region Information
################################################################################

# Get current AWS account information
data "aws_caller_identity" "current" {}

# Get current AWS region
data "aws_region" "current" {}
