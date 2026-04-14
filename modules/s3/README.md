Absolutely! Here's a **professional, industry-standard README** for your reusable S3 Terraform module. It’s written so anyone in a DevOps team can pick it up, understand the features, and use it correctly.

---

# 📦 Terraform S3 Module

## Overview

This Terraform module creates **AWS S3 buckets** with configurable options for:

* **Private buckets** (default, secure)
* **Static website hosting** (public access with optional folder upload)
* **Versioning**
* **Server-side encryption**
* **Lifecycle management**
* **Enterprise-grade tags and naming conventions**

This module follows **industry best practices**: private by default, configurable, reusable, and suitable for multi-environment deployments.

---

## Features

✅ Create **private or public buckets**
✅ Enable **S3 Versioning**
✅ Enable **Server-Side Encryption (SSE)**
✅ Configure **Static Website Hosting**
✅ Upload a **complete folder** for static websites
✅ Configure **Lifecycle Rules** (object expiration, version expiration)
✅ Configure **Public Access Policies** automatically
✅ Fully **parameterized via variables**
✅ Tags support for **environment, project, owner, etc.**

---

## Usage

### Root Module Structure

```
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── modules/
    └── s3/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

### Example: Private Bucket

```hcl
aws_region            = "us-east-1"
bucket_name           = "company-prod-private-bucket"
enable_static_website = false
enable_lifecycle      = true

tags = {
  Environment = "prod"
  Owner       = "platform-team"
}
```

### Example: Static Website Bucket

```hcl
aws_region            = "us-east-1"
bucket_name           = "company-dev-static-site"
enable_static_website = true
upload_folder_path    = "./website"

tags = {
  Environment = "dev"
  Owner       = "frontend-team"
}
```

---

## Inputs

| Name                                 | Type        | Default                    | Description                                      |
| ------------------------------------ | ----------- | -------------------------- | ------------------------------------------------ |
| `bucket_name`                        | string      | n/a                        | Name of the S3 bucket                            |
| `force_destroy`                      | bool        | `false`                    | Allow destroying bucket even if not empty        |
| `enable_versioning`                  | bool        | `true`                     | Enable S3 bucket versioning                      |
| `sse_algorithm`                      | string      | `"AES256"`                 | Server-side encryption algorithm                 |
| `enable_static_website`              | bool        | `false`                    | Enable static website hosting                    |
| `index_document`                     | string      | `"index.html"`             | Website index document                           |
| `error_document`                     | string      | `"error.html"`             | Website error document                           |
| `upload_folder_path`                 | string      | `""`                       | Local folder path to upload (for static website) |
| `enable_lifecycle`                   | bool        | `false`                    | Enable S3 lifecycle rules                        |
| `lifecycle_rule_id`                  | string      | `"default-lifecycle-rule"` | Lifecycle rule ID                                |
| `lifecycle_prefix`                   | string      | `""`                       | Prefix filter for lifecycle rules                |
| `lifecycle_expiration_days`          | number      | `30`                       | Days before object expiration                    |
| `noncurrent_version_expiration_days` | number      | `30`                       | Days before version expiration                   |
| `tags`                               | map(string) | `{}`                       | Tags for the bucket                              |
| `mime_types`                         | map(string) | See defaults               | Custom MIME type mapping for uploaded files      |

---

## Outputs

| Name               | Description                                  |
| ------------------ | -------------------------------------------- |
| `bucket_id`        | ID of the S3 bucket                          |
| `bucket_arn`       | ARN of the S3 bucket                         |
| `bucket_name`      | Name of the bucket                           |
| `website_endpoint` | Website endpoint (if static hosting enabled) |
| `website_domain`   | Website domain (if static hosting enabled)   |

---

## Best Practices

* **Private by default**: Buckets are private unless `enable_static_website = true`.
* **Do not hardcode values**: Use variables for environment, project, and bucket names.
* **Use lifecycle rules** to manage object expiration and version cleanup.
* **Upload entire folders** via `upload_folder_path` for static websites.
* **Tag buckets consistently** for cost tracking and compliance.

---

## Advanced Usage

* Combine with **CloudFront** for secure static website hosting.
* Integrate with **Route53** for custom domain names.
* Enable **KMS encryption** for sensitive data.
* Use **aliased providers** to manage multiple AWS accounts.

---

## References

* [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
* [AWS S3 Best Practices](https://docs.aws.amazon.com/AmazonS3/latest/userguide/best-practices.html)

---

This README ensures that your module is **production-ready**, clear, and professional for a DevOps or Platform Engineering team.

---

