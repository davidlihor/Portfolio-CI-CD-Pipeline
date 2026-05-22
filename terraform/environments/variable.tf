variable "github_owner" {
  type    = string
  default = "davidlihor"
}

variable "github_repo" {
  type    = string
  default = "portfolio-ci-cd-pipeline"
}

variable "github_branch" {
  type    = string
  default = "main"
}

locals {
  github_sub_claims = distinct([
    "repo:${var.github_owner}/${var.github_repo}:ref:refs/heads/${var.github_branch}",
    "repo:${lower(var.github_owner)}/${lower(var.github_repo)}:ref:refs/heads/${var.github_branch}"
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
