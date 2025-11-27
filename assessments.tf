# Assessment Resources for AWS Audit Manager

################################################################################
# AWS Audit Manager Assessments
################################################################################

resource "aws_auditmanager_assessment" "main" {
  for_each = local.create_assessments ? { for assessment in var.assessments : assessment.name => assessment } : {}

  name         = each.value.name
  description  = lookup(each.value, "description", "Assessment for ${each.value.name}")
  framework_id = each.value.framework_id

  # Assessment scope configuration
  scope {
    # AWS accounts in scope
    dynamic "aws_accounts" {
      for_each = each.value.scope.aws_accounts
      content {
        id = aws_accounts.value
      }
    }

    # AWS services in scope
    dynamic "aws_services" {
      for_each = each.value.scope.aws_services
      content {
        service_name = aws_services.value
      }
    }
  }

  # Assessment roles
  dynamic "roles" {
    for_each = each.value.roles
    content {
      role_arn  = roles.value.role_arn
      role_type = roles.value.role_type
    }
  }

  # Assessment reports destination (optional)
  dynamic "assessment_reports_destination" {
    for_each = lookup(each.value, "assessment_reports_destination", null) != null ? [each.value.assessment_reports_destination] : []
    content {
      destination      = assessment_reports_destination.value.destination
      destination_type = assessment_reports_destination.value.destination_type
    }
  }

  tags = merge(
    var.tags,
    {
      Name      = each.value.name
      Purpose   = "AWS Audit Manager Assessment"
      ManagedBy = "Terraform"
    }
  )

  # Allow updates to assessments without forcing recreation
  lifecycle {
    create_before_destroy = true
  }

  # Ensure Audit Manager is enabled before creating assessments
  depends_on = [
    aws_auditmanager_account_registration.main
  ]
}
