resource "aws_iam_role" "webhooks_receiver_role" {
  name = "WebhooksReceiverRole"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = "AssumeRoleFromEC2"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "WebhooksReceiverExecutionPolicy"

    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "ScopedECREffects",
          "Effect" : "Allow",
          "Action" : [
            "ecr:DescribeImageScanFindings",
            "ecr:GetLifecyclePolicyPreview",
            "ecr:GetDownloadUrlForLayer",
            "ecr:DescribeImageReplicationStatus",
            "ecr:ListTagsForResource",
            "ecr:ListImages",
            "ecr:BatchGetRepositoryScanningConfiguration",
            "ecr:BatchGetImage",
            "ecr:DescribeImages",
            "ecr:DescribeRepositories",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetRepositoryPolicy",
            "ecr:GetLifecyclePolicy"
          ],
          "Resource" : "arn:aws:ecr:eu-west-1:715820034474:repository/webhooks_receiver"
        },
        {
          "Sid" : "PublicECREffects",
          "Effect" : "Allow",
          "Action" : [
            "ecr:GetRegistryPolicy",
            "ecr:DescribeRegistry",
            "ecr:DescribePullThroughCacheRules",
            "ecr:GetAuthorizationToken",
            "ecr:GetRegistryScanningConfiguration"
          ],
          "Resource" : "*"
        }
      ]
    })
  }
}
