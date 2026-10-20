provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "SkynetAI-Labs-DevSecOps-Lab4"
      Environment = "Lab"
      ManagedBy   = "Terraform"
    }
  }
}
