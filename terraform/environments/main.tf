terraform {
  backend "s3" {
    bucket         = "portfolio-tf-state-405483480335-eu-central-1-an"
    key            = "production/portfolio/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    use_lockfile   = true
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

module "portfolio_website" {
  source       = "../modules/static_website"
  domain_name  = var.domain_name
  project_name = var.project_name
  environment  = var.environment

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }
}
