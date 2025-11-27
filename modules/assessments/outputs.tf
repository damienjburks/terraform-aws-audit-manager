output "assessment_ids" {
  description = "Map of assessment names to IDs"
  value = var.create_assessments ? {
    for name, assessment in aws_auditmanager_assessment.main : name => assessment.id
  } : {}
}

output "assessment_arns" {
  description = "Map of assessment names to ARNs"
  value = var.create_assessments ? {
    for name, assessment in aws_auditmanager_assessment.main : name => assessment.arn
  } : {}
}
