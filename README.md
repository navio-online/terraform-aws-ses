Cloned from: https://github.com/trussworks/terraform-aws-ses-domain.git

Configures a domain hosted on Route53 to work with AWS Simple Email Service (SES).

## Prerequisites

* Ensure [terraform](https://www.terraform.io/intro/getting-started/install.html) is installed
* Ensure domain is registered in [route53](https://aws.amazon.com/route53/)
* Ensure an s3 bucket exists and SES has write permissions to it
* If you have an existing rule set you can skip creating the dependent resource
* Route53 zone id can be obtained by looking up the domain in route53 service

## Getting Started

1. Import the module called `ses_domain` and update its source property to `trussworks/ses-domain/aws` and run `terrafrom init`
2. The next step is to configure the module with [minimum values](#usage) for SES to start working
3. Once fully configured run `terraform plan` to see the execution plan and `terrafrom apply` to stand up SES

Creates the following resources:

* MX record pointing to AWS's SMTP endpoint
* TXT record for SPF validation
* Custom MAIL FROM domain
* CNAME records for DKIM verification
* SES Verfication for the domain

## Usage

See [examples](examples/) for functional examples on how to use this module.

```hcl
module "ses_domain" {
  source             = "trussworks/ses-domain/aws"
  domain_name        = "example.com"
  mail_from_domain   = "email.example.com"
  route53_zone_id    = data.aws_route53_zone.ses_domain.zone_id
  from_addresses     = ["email1@example.com", "email2@example.com"]
  dmarc_rua          = "something@example.com"
  receive_s3_bucket  = "S3_bucket_with_write_permissions"
  receive_s3_prefix  = "path_to_store_received_emails"
  ses_rule_set       = "name-of-the-ruleset"
}

resource "aws_ses_receipt_rule_set" "name-of-the-ruleset" {
  rule_set_name = "name-of-the-ruleset"
}

data "aws_route53_zone" "SES_domain" {
  name = "example.com"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| dmarc\_p | DMARC Policy for organizational domains (none, quarantine, reject). | `string` | `"none"` | no |
| dmarc\_rua | DMARC Reporting URI of aggregate reports, expects an email address. | `string` | n/a | yes |
| domain\_name | The domain name to configure SES. | `string` | n/a | yes |
| enable\_incoming\_email | Control whether or not to handle incoming emails. | `bool` | `true` | no |
| enable\_spf\_record | Control whether or not to set SPF records. | `bool` | `true` | no |
| enable\_verification | Control whether or not to verify SES DNS records. | `bool` | `true` | no |
| from\_addresses | List of email addresses to catch bounces and rejections. | `list(string)` | n/a | yes |
| mail\_from\_domain | Subdomain (of the route53 zone) which is to be used as MAIL FROM address | `string` | n/a | yes |
| receive\_s3\_bucket | Name of the S3 bucket to store received emails (required if enable\_incoming\_email is true). | `string` | `""` | no |
| receive\_s3\_prefix | The key prefix of the S3 bucket to store received emails (required if enable\_incoming\_email is true). | `string` | `""` | no |
| route53\_zone\_id | Route53 host zone ID to enable SES. | `string` | n/a | yes |
| ses\_rule\_set | Name of the SES rule set to associate rules with. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ses\_identity\_arn | SES identity ARN. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
