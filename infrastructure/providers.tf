provider "aws" {
  region  = "eu-west-1"

  default_tags {
    tags = {
      Environment = "Staging"
      Iac         = "Terraform"
      Owner       = "Ofadiman"
      Project     = "WebhooksReceiver"
    }
  }
}
