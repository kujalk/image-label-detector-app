// For image storage
resource "random_string" "random" {
  length  = 8
  numeric = false
  special = false
  lower   = true
  upper   = false
}

resource "aws_s3_bucket" "storage" {
  bucket        = "${var.project}${random_string.random.id}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "public-block-storage" {
  bucket = aws_s3_bucket.storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

resource "aws_s3_bucket_cors_configuration" "example" {
  bucket = aws_s3_bucket.storage.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET",
      "HEAD",
      "PUT",
      "POST",
    "DELETE"]
    allowed_origins = ["*"]
    expose_headers = ["x-amz-server-side-encryption",
      "x-amz-request-id",
      "x-amz-id-2",
    "ETag"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

// Bucket for Front end
resource "aws_s3_bucket" "frontend" {
  bucket        = var.front_end_bucket
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "public-block" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

}

resource "aws_s3_bucket_policy" "prod_website" {
  bucket     = aws_s3_bucket.frontend.id
  depends_on = [aws_s3_bucket_public_access_block.public-block]
  policy     = <<POLICY
{    
    "Version": "2012-10-17",    
    "Statement": 
    [ 
        {
            "Sid": "Read-access",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.frontend.id}/*"
        }
    ]
}
POLICY
}

resource "aws_s3_bucket_website_configuration" "web" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}