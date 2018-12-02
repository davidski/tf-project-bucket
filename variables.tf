variable "aws_region" {
  default = "us-west-2"
}

variable "project" {}

variable "aws_profile" {
  description = "Name of AWS profile to use for API access."
  default     = "default"
}

variable "audit_bucket" {
  description = "Name of the audit log bucket"
}
