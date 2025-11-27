# Assessments Module for AWS Audit Manager

resource "aws_auditmanager_assessment" "main" {
  for_each = var.create_assessments ? { for assessment in var.assessments : assessment.name => assessment } : {}

  name         = each.value.name
  description  = lookup(each.value, "description", "Assessment for ${each.value.name}")
  framework_id = each.value.framework_id

  scope {
    dynamic "aws_accounts" {
      for_each = each.value.scope.aws_accounts
      content {
        id = aws_accounts.value
      }
    }

    dynamic "aws_services" {
      for_each = each.value.scope.aws_services
      content {
        service_name = aws_services.value
      }
    }
  }

  dynamic "roles" {
    for_each = each.value.roles
    content {
      role_arn  = roles.value.role_arn
      role_type = roles.value.role_type
    }
  }

  assessment_reports_destination {
    destination      = lookup(each.value, "assessment_reports_destination", null) != null ? each.value.assessment_reports_destination.destination : "s3://${var.evidence_bucket_name}"
    destination_type = lookup(each.value, "assessment_reports_destination", null) != null ? each.value.assessment_reports_destination.destination_type : "S3"
  }

  tags = merge(
    var.tags,
    {
      Name      = each.value.name
      Purpose   = "AWS Audit Manager Assessment"
      ManagedBy = "Terraform"
    }
  )

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [var.audit_manager_enabled]
}
