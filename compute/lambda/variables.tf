variable "region" {
  type = string
  description = "The AWS region name to create/manage the resource in"
  default = "eu-west-2"
}

variable "bucket_prefix" {
  type = string
  description = "The prefix to use for the s3 bucket name"
  default = "pacator-gopizza-lambda-functions20230315153525618700000001"
}

variable "bucket_key" {
  type = string
  description = "The key to use for the code"
  default = "LambdaFunctions.zip"
}

variable "lambda_runtime" {
  type = string
  description = "The runtime"
  default = "nodejs16.x"
}

variable "lambda_timeout" {
    type = string
    description = "The timeout set"
    default = 10
}
