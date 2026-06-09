# Remote S3 backend — stores Terraform state so CI/CD pipelines
# running on ephemeral GitHub Actions runners do not lose state
# between executions.
terraform {
  backend "s3" {
    bucket       = "cd-ci-463032375612"
    key          = "iac-multi-cloud/terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
    encrypt      = true
  }
}
