resource "aws_iam_user" "new_user" {
  name = var.iam_username
}

resource "aws_iam_user_login_profile" "login" {
  user = aws_iam_user.new_user.name
}

resource "aws_s3_bucket" "bucket" {
  bucket_prefix = var.bucket_prefix

  tags = {
    "Name" = "GoPizza bucket"
    "Environment" = "Dev"
  }
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "object" {
  bucket  = aws_s3_bucket.bucket.id
  key     = "LambdaFunctions.zip"
}

resource "aws_s3_bucket_acl" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  
  acl = "public-read"
}

resource "aws_s3_bucket_public_access_block" "app" {
  bucket = aws_s3_bucket.bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_iam_policy" "policy" {
  name = "${aws_s3_bucket.bucket.id}-policy"
  description = "GoPizza Lambda Functions policy"

  policy  = data.aws_iam_policy_document.public_read_write_access.json
}

data "aws_iam_policy_document" "public_read_write_access" {
  statement {
    actions   = ["s3:ListAllMyBuckets","s3:GetBucketLocation"]
    resources = ["arn:aws:s3:::*"]
    effect = "Allow"
  }
  statement {
    actions   =[ "s3:GetObject", "s3:PutObject", "s3:DeleteObject","s3:ListBucket" ]
    resources = [aws_s3_bucket.bucket.arn]
    effect = "Allow"
  }
}

resource "aws_iam_user_policy_attachment" "attachment" {
  user       = aws_iam_user.new_user.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_s3_bucket_policy" "public_read_write_access" {
  bucket = aws_s3_bucket.bucket.id
  policy = <<POLICY
  {
    "Id": "Policy1678210801113",
    "Version": "2012-10-17",
    "Statement": [
      {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": ["${aws_s3_bucket.bucket.arn}","${aws_s3_bucket.bucket.arn}/*"]
      }
    ]
  }
  POLICY
}

resource "aws_s3_bucket_website_configuration" "website-config" {
  bucket = aws_s3_bucket.bucket.id
index_document {
    suffix = "goPizza.html"
  }
error_document {
    key = "404.html"
  }
}
