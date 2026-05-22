variable "github_owner" {
  type    = string
  default = "davidlihor"
}

variable "github_repo" {
  type    = string
  default = "Portfolio-CI-CD-Pipeline"
}

locals {
  github_sub_claims = distinct([
    "repo:${var.github_owner}/${var.github_repo}:*",
    "repo:${lower(var.github_owner)}/${lower(var.github_repo)}:*"
  ])
}

variable "domain_name" {
  type    = string
  default = "davidlihor.com"
}

variable "project_name" {
  type    = string
  default = "portfolio-davidlihor"
}

variable "environment" {
  type    = string
  default = "production"
}

variable "region" {
  type    = string
  default = "eu-central-1"
}
