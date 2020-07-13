variable "bucket_name" {
  type = string
  description = "S3 bucket name"
}

variable "readonly_arns" {
  description = "list of ARN to grant read only access."
  type        = list(string)
  default     = []
}

variable "readwrite_arns" {
  description = "list of ARN to grant read and write access."
  type        = list(string)
  default     = []
}

variable "admin_arns" {
  description = "A list of IAM ARNs to grant administration access."
  type        = list(string)
  default     = []
}
