//IAM role for apigw-dynamodb lambda
resource "aws_iam_role" "cognito" {
  name = "${var.project}-cognito-authenticated-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "cognito-identity.amazonaws.com"
            },
            "Action": [
                "sts:AssumeRoleWithWebIdentity",
                "sts:TagSession"
            ],
            "Condition": {
                "StringEquals": {
                    "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.id.id}"
                },
                "ForAnyValue:StringLike": {
                    "cognito-identity.amazonaws.com:amr": "authenticated"
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_policy" "cognito" {
  name        = "${var.project}-cognito-policy"
  path        = "/"
  description = "${var.project} Cognito IAM policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "${aws_s3_bucket.storage.arn}/private/$${cognito-identity.amazonaws.com:sub}/*",
          "${aws_s3_bucket.storage.arn}/private/$${cognito-identity.amazonaws.com:sub}"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = [
          "${aws_s3_bucket.storage.arn}/uploads/*"
        ]
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "cognito" {
  role       = aws_iam_role.cognito.name
  policy_arn = aws_iam_policy.cognito.arn
}
