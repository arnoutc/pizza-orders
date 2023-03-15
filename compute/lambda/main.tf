resource "aws_lambda_function" "PlaceOrder" {
  function_name = "PlaceOrder"
  handler = "PlaceOrder.handler"
  role = aws_iam_role.ExecuteLambdaRole.arn
  runtime = var.lambda_runtime
  timeout = var.lambda_timeout
  description = "places order in DynamoDB table"
  s3_bucket = var.bucket_prefix
  s3_key = var.bucket_key
  depends_on = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role_lambda]
}

resource "aws_lambda_function" "ProcessPayment" {
  function_name = "ProcessPayment"
  handler = "ProcessPayment.handler"
  role = aws_iam_role.ExecuteLambdaRole.arn
  runtime = var.lambda_runtime
  timeout = var.lambda_timeout
  description = "processes the payment"
  s3_bucket = var.bucket_prefix
  s3_key = var.bucket_key
  depends_on = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role_lambda]
}

resource "aws_lambda_function" "ConfirmOrder" {
  function_name = "ConfirmOrder"
  handler = "ConfirmOrder.handler"
  role = aws_iam_role.ExecuteLambdaRole.arn
  runtime = var.lambda_runtime
  timeout = var.lambda_timeout
  description = "makes the order status confirmed"
  s3_bucket = var.bucket_prefix
  s3_key = var.bucket_key
  depends_on = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role_lambda]
}

resource "aws_lambda_function" "CancelOrder" {
  function_name = "CancelOrder"
  handler = "CancelOrder.handler"
  role = aws_iam_role.ExecuteLambdaRole.arn
  runtime = var.lambda_runtime
  timeout = var.lambda_timeout
  description = "cancels the order"
  s3_bucket = var.bucket_prefix
  s3_key = var.bucket_key
  depends_on = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role_lambda]
}

resource "aws_lambda_function" "NotifyUser" {
  function_name = "NotifyUser"
  handler = "NotifyUser.handler"
  role = aws_iam_role.ExecuteLambdaRole.arn
  runtime = var.lambda_runtime
  timeout = var.lambda_timeout
  description = "notifies order status to the user"
  s3_bucket = var.bucket_prefix
  s3_key = var.bucket_key
  depends_on = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role_lambda]
}

resource "aws_lambda_function" "NotifyWithPolly" {
  function_name = "NotifyWithPolly"
  handler = "NotifyWithPolly.handler"
  role = aws_iam_role.ExecuteLambdaRole.arn
  runtime = var.lambda_runtime
  timeout = var.lambda_timeout
  description = "converts order status to speech and uploads mp3 file on S3"
  s3_bucket = var.bucket_prefix
  s3_key = var.bucket_key
  depends_on = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role_lambda]
}
