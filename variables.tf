variable "iam_role_name" {
  description = "The name of the IAM role to create."
  type        = string
}

variable "trusted_principal_arns" {
  description = "List of ARNs of principals (IAM users, roles, or AWS services) that are allowed to assume this role."
  type        = list(string)
}

variable "trusted_sts_actions" {
  description = "List of STS actions that the trusted principals are allowed to perform (e.g. sts:AssumeRole, sts:AssumeRoleWithWebIdentity)."
  type        = list(string)
}

variable "managed_policy_arns" {
  description = "List of IAM managed policy ARNs to attach to the role."
  type        = list(string)
  default     = []
}

variable "custom_policies" {
  description = "List of custom IAM policies to create and attach to the role."
  type = list(object({
    name        = string
    description = optional(string)
    policy_json = string
  }))
  default = []
}

variable "max_session_duration_seconds" {
  description = "Maximum session duration (in seconds) for the IAM role. Must be between 3600 and 43200."
  type        = number
}

variable "role_path" {
  description = "Path for the IAM role."
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Map of tags to assign to the IAM role."
  type        = map(string)
  default     = {}
}
