variable "region" {
  type = string
  description = "The AWS region name to create/manage the resource in"
  default = "eu-west-2"
}

variable "bucket_prefix" {
  type = string
  description = "The prefix to use for the s3 bucket name"
  default = "pacator-gopizza-lambda-functions"
}

variable "upload_source" {
    type = string
    description = "The source file to upload"
    default = "LambdaFunctions.zip"
}

variable "iam_username" {
  type = string
  description = "The IAM username to use"
  default = "gopizza_user"
}