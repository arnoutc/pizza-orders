resource "aws_iam_role" "ExecuteLambdaRole" {
  name = "ExecuteLambdaRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole"
        ]
      }
    ]
  })
  path = "/"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonPollyFullAccess",
  ]
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
    name         = "aws_iam_policy_for_terraform_aws_lambda_role"
    path         = "/"
    description  = "AWS IAM Policy for managing aws lambda role"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*",
        "Effect": "Allow"
    },
    {
        "Sid": "Stmt1464440182000",
        "Effect": "Allow",
        "Action": [
            "lambda:InvokeAsync",
            "lambda:InvokeFunction"
        ],
        "Resource": [
          "arn:aws:lambda:eu-west-2:009831754594:function:PlaceOrder", 
          "arn:aws:lambda:eu-west-2:009831754594:function:ProcessPayment",
          "arn:aws:lambda:eu-west-2:009831754594:function:ConfirmOrder",
          "arn:aws:lambda:eu-west-2:009831754594:function:CancelOrder",
          "arn:aws:lambda:eu-west-2:009831754594:function:NotifyUser",
          "arn:aws:lambda:eu-west-2:009831754594:function:NotifyWithPolly"
        ]
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role_lambda" {
    role        = aws_iam_role.ExecuteLambdaRole.name
    policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}