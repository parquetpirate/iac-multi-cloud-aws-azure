# Multi-cloud Terraform configuration (AWS + Azure)

# Required Terraform version
terraform {
  required_version = "~> 1.15"

  # Declare required providers and their minimum versions
  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.76.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "6.49.0"
    }
  }
}

# Azure provider configuration
# OIDC authentication is used for CI/CD pipeline (no secrets needed at runtime)
provider "azurerm" {
  features {}
  use_oidc = true
}

# AWS provider configuration
provider "aws" {
  region = "us-east-2"
}
