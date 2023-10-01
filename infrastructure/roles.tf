//IAM role for s3-rekognition-dynamodb lambda
resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.project}-s3-rekognition-dynamodb-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["lambda.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "${var.project}-lambda-logging-policy"
  path        = "/"
  description = "${var.project} lambda logging IAM policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "s3:Get*",
          "s3:List*",
          "s3:Describe*",
          "s3-object-lambda:Get*",
          "s3-object-lambda:List*"
        ]
        Resource = [
          "arn:aws:logs:*:*:*",
          aws_s3_bucket.storage.arn,
          "${aws_s3_bucket.storage.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "rekognition:ListTagsForResource",
          "rekognition:ListDatasetEntries",
          "rekognition:ListDatasetLabels",
          "rekognition:DescribeDataset",
          "rekognition:GetLabelDetection",
          "rekognition:DetectLabels"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["dynamodb:*"]
        Resource = aws_dynamodb_table.dbtable.arn
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRekognitionCustomLabelsFullAccess"
  role       = aws_iam_role.iam_for_lambda.name
}

//IAM role for apigw-dynamodb lambda
resource "aws_iam_role" "iam_for_apigw_lambda" {
  name = "${var.project}-apigw-dynamodb-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["lambda.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "apigw_lambda" {
  name        = "${var.project}-apigw-dynamodb-lambda-policy"
  path        = "/"
  description = "${var.project} apigw-dynamodb lambda IAM policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:BatchGetItem",
          "dynamodb:Describe*",
          "dynamodb:List*",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:PartiQLSelect"
        ]
        Resource = aws_dynamodb_table.dbtable.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "apigw_lambda" {
  role       = aws_iam_role.iam_for_apigw_lambda.name
  policy_arn = aws_iam_policy.apigw_lambda.arn
}

resource "aws_iam_role_policy_attachment" "apigw_lambda_ro" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonCognitoReadOnly"
  role       = aws_iam_role.iam_for_apigw_lambda.name
}
