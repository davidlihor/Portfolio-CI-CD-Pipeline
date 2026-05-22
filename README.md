# Portfolio CI/CD Pipeline

An automated, GitOps-driven deployment pipeline that builds, ships, and serves a portfolio website on AWS. This project demonstrates enterprise-grade infrastructure-as-code (IaC) modularity and secure CI/CD practices for static site delivery.

## Overview

Modern static sites require more than just uploading HTML to a server — they demand automation, security, and global edge caching. In this project, every push to the `main` branch triggers a GitHub Actions workflow that securely syncs site assets to AWS S3 and invalidates the CloudFront cache, delivering updates to a custom domain ([davidlihor.com](https://davidlihor.com)) within minutes. 

The infrastructure is defined entirely in Terraform using a **modular architecture**. Instead of a flat directory structure, the setup separates reusable modules from environment-specific configurations, mirroring how production SRE teams manage infrastructure at scale. The deployment pipeline uses **Keyless Authentication via OIDC**, eliminating the risk of long-lived AWS credentials leaking from GitHub Secrets.

## Architecture

![](screenshots/cloud-architecture.png)

The architecture is designed for high availability, low latency, and zero-trust security:

**Traffic Flow:** DNS resolution through Route53 directs traffic to a CloudFront distribution, which serves cached content globally from 450+ edge locations. CloudFront handles TLS termination using an ACM certificate (provisioned in `us-east-1`) and enforces HTTPS by redirecting all HTTP requests.

**Origin Security:** The S3 bucket acts as a private origin with all public access blocked. CloudFront uses **Origin Access Control (OAC)** to authenticate requests at the edge, ensuring that content can *only* be accessed through the CDN. This prevents direct bucket enumeration, bypasses, or unauthorized access.

**Deployment Flow:** GitHub Actions checks out the repository, assumes a temporary AWS IAM role via OIDC federation (no static credentials), syncs the static assets to S3 with path exclusions for infrastructure files, and explicitly invalidates the CloudFront cache (`/*`) to propagate changes globally.

## Tech Stack

**Infrastructure**: AWS S3, CloudFront, Route53, ACM, IAM — all provisioned via Terraform with modular architecture

**CI/CD**: GitHub Actions (OIDC-authenticated) with path-scoped triggers and automated cache invalidation

**Frontend**: HTML, CSS, JavaScript (Static Assets)

**Security**: CloudFront Origin Access Control (OAC), Keyless CI/CD Authentication, Enforced HTTPS

## Key Decisions

- **Modular Terraform Architecture over Flat Files**: The Terraform code is split into a reusable `static_website` module (`terraform/modules/static_website/`) and environment-specific instantiations (`terraform/environments/main.tf`). This allows the infrastructure to be easily scaled across multiple environments (e.g., `staging`, `prod`) without code duplication, following enterprise IaC best practices that separate concerns and enable parallel environment management.

- **Keyless Authentication (OIDC) over Static IAM Credentials**: Instead of storing long-lived IAM access keys in GitHub Secrets (which can leak in logs, be compromised, and require manual rotation), the CI/CD pipeline uses OpenID Connect (OIDC) to assume a scoped IAM role dynamically. GitHub Actions proves its identity to AWS via a signed JWT token, receives temporary credentials valid for 1 hour, and never handles permanent keys. This significantly reduces the attack surface and eliminates credential rotation overhead.

- **CloudFront Origin Access Control (OAC) over Public S3**: The S3 bucket is completely private — public access is blocked at the bucket policy level. OAC ensures that traffic is strictly authenticated at the CloudFront edge using AWS Signature Version 4, preventing anyone from bypassing the CDN and accessing the origin directly. This is the modern replacement for Origin Access Identity (OAI), with better security and support for SSE-KMS.

- **Cache Invalidation as a Pipeline Step**: Rather than waiting for the CDN Time-To-Live (TTL) to expire (which could take up to 24 hours), the GitHub Actions workflow triggers an explicit CloudFront invalidation immediately after the S3 sync. This guarantees that visitors always see the latest version of the portfolio within seconds of a successful merge to `main`, without sacrificing the performance benefits of long-lived cache entries for static assets.

- **Path-Scoped Workflow Triggers**: The GitHub Actions workflow only fires when content files change (`index.html`, images, PDF), not on Terraform or CI/CD config changes. This avoids unnecessary deployments, reduces S3 API costs, and keeps the deployment log clean and focused on actual content releases.

## Screenshots

**Portfolio Homepage** — The live deployed website served globally via CloudFront and S3, demonstrating the successful delivery of the CI/CD pipeline with sub-second response times and HTTPS encryption.

![](screenshots/portfolio-homepage.png)

## Author

**David Lihor**

- Website: [davidlihor.com](https://davidlihor.com)
- GitHub: [github.com/davidlihor](https://github.com/davidlihor)
- LinkedIn: [linkedin.com/in/david-lihor](https://www.linkedin.com/in/david-lihor)
