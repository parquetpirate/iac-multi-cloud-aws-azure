# ── General ──────────────────────────────────────────────────────────────────

variable "name" {
  description = "Prefix used for resource naming"
  type        = string
  default     = "azureaws"
}

# ── AWS ──────────────────────────────────────────────────────────────────────

variable "aws_public_subnet_cidr_1" {
  type        = string
  description = "CIDR block for the first public subnet"
  default     = "10.0.10.0/24"
}

variable "aws_public_subnet_cidr_2" {
  type        = string
  description = "CIDR block for the second public subnet"
  default     = "10.0.11.0/24"
}

variable "aws_private_subnet_cidr_1" {
  type        = string
  description = "CIDR block for the first private subnet"
  default     = "10.0.20.0/24"
}

variable "aws_private_subnet_2" {
  type        = string
  description = "CIDR block for the second private subnet"
  default     = "10.0.21.0/24"
}

variable "aws_az_1" {
  type        = string
  description = "Availability zone for the first subnet"
  default     = "us-east-2a"
}

variable "aws_az_2" {
  type        = string
  description = "Availability zone for the second subnet"
  default     = "us-east-2b"
}

# ── Azure ────────────────────────────────────────────────────────────────────

variable "resource_group_location" {
  type        = string
  default     = "eastus2"
  description = "Azure region for the resource group and all its resources"
}

variable "vm_admin_password" {
  type        = string
  default     = "Password123!"
  sensitive   = true
  description = "Admin password for the Azure Linux VM"
}
