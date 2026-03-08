# terraform-aws-cloud-access-role

A Terraform module that creates an AWS IAM role assumable by specified trusted principal ARNs.

## Usage

```hcl
module "cloud_access_role" {
  source = "fourcee/cloud-access-role/aws"

  iam_role_name          = "my-cross-account-role"
  trusted_principal_arns = ["arn:aws:iam::123456789012:root"]
  trusted_sts_actions    = ["sts:AssumeRole"]
  managed_policy_arns    = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]

  custom_policies = [
    {
      name        = "my-custom-policy"
      description = "A custom policy for this role"
      policy_json = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect   = "Allow"
            Action   = ["s3:GetObject"]
            Resource = ["arn:aws:s3:::my-bucket/*"]
          }
        ]
      })
    }
  ]

  max_session_duration_seconds = 3600
  role_path                    = "/"

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

output "role_arn" {
  value = module.cloud_access_role.role_arn
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| iam\_role\_name | The name of the IAM role to create. | `string` | n/a | yes |
| trusted\_principal\_arns | List of ARNs of principals allowed to assume this role. | `list(string)` | n/a | yes |
| trusted\_sts\_actions | List of STS actions the trusted principals are allowed to perform. | `list(string)` | n/a | yes |
| managed\_policy\_arns | List of IAM managed policy ARNs to attach to the role. | `list(string)` | `[]` | no |
| custom\_policies | List of custom IAM policies to create and attach to the role. | `list(object({ name = string, description = optional(string), policy_json = string }))` | `[]` | no |
| max\_session\_duration\_seconds | Maximum session duration in seconds (3600–43200). | `number` | n/a | yes |
| role\_path | Path for the IAM role. | `string` | `"/"` | no |
| tags | Map of tags to assign to the IAM role. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| role\_arn | The ARN of the IAM role. |