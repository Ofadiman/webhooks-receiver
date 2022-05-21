resource "aws_ecr_repository" "webhooks_receiver_ecr_repository" {
  name = "webhooks_receiver"
  tags = {}
}

output "webhooks_receiver_ecr_repository" {
  value       = aws_ecr_repository.webhooks_receiver_ecr_repository.name
  description = "ECR repository name for webhooks receiver project."
}
