variable "domain_name" {
  description = "Base domain name, for example awsclouddash.click."
  type        = string
}

variable "certificate_domain_name" {
  description = "FQDN for the certificate, for example staging.awsclouddash.click."
  type        = string
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}