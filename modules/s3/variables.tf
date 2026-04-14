variable "bucket_name" {
  type = string
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "enable_versioning" {
  type    = bool
  default = true
}

variable "sse_algorithm" {
  type    = string
  default = "AES256"
}

variable "enable_static_website" {
  type    = bool
  default = false
}

variable "index_document" {
  type    = string
  default = "index.html"
}

variable "error_document" {
  type    = string
  default = "error.html"
}

variable "upload_folder_path" {
  type    = string
  default = ""
}

variable "enable_lifecycle" {
  type    = bool
  default = false
}

variable "lifecycle_rule_id" {
  type    = string
  default = "default-lifecycle-rule"
}

variable "lifecycle_prefix" {
  type    = string
  default = ""
}

variable "lifecycle_expiration_days" {
  type    = number
  default = 30
}

variable "noncurrent_version_expiration_days" {
  type    = number
  default = 30
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "mime_types" {
  type = map(string)
  default = {
    ".html" = "text/html"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".svg"  = "image/svg+xml"
    ".json" = "application/json"
  }
}