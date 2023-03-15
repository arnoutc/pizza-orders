# Create IAM role for AWS Step Function
resource "aws_iam_role" "iam_for_sfn" {
  name = "stepFunctionSampleStepFunctionExecutionIAM"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "states.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy_invoke_lambda" {
    name         = "policy_invoke_lambda"
    path         = "/"
    description  = "AWS IAM Policy for invoking aws lambda role"
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

// Attach policy to IAM Role for Step Function
resource "aws_iam_role_policy_attachment" "iam_for_sfn_attach_policy_invoke_lambda" {
  role       = "${aws_iam_role.iam_for_sfn.name}"
  policy_arn = "${aws_iam_policy.policy_invoke_lambda.arn}"
}


module "step_function" {
  source = "terraform-aws-modules/step-functions/aws"

  name = "pizza-orders-step-function"
  role_arn = "${aws_iam_role.iam_for_sfn.arn}"
  
  definition = <<EOF
    {
        "Comment": "Pizza Order State Machine.",
        "StartAt": "PlaceOrder",
        "States": {
            "PlaceOrder": {
                "Type": "Task",
                "Resource": "${var.place-order}",
                "Next": "ProcessPayment"
            },
            "ProcessPayment": {
                "Type": "Task",
                "Resource": "${var.process-payment}",
                "Next": "IsPaymentSuccessful"
            },
            "IsPaymentSuccessful": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.paymentSuccess",
                        "BooleanEquals": true,
                        "Next": "ConfirmOrder"
                    },
                    {
                        "Variable": "$.paymentSuccess",
                        "BooleanEquals": false,
                        "Next": "CancelOrder"
                    }
                ]
            },
            "ConfirmOrder": {
                "Type": "Task",
                "Resource": "${var.confirm-order}",
                "Next": "NotifyUser"
            },
            "CancelOrder": {
                "Type": "Task",
                "Resource": "${var.cancel-order}",
                "Next": "NotifyUser"
            },
            "NotifyUser": {
                "Type": "Task",
                "Resource": "${var.notify-user}",
                "Next": "NotifyWithPolly"
            },
        
            "NotifyWithPolly": {
                "Type": "Task",
                "Resource": "${var.notify-with-polly}",
                "End": true
            }
        }
    }
  EOF

  service_integrations = {
    lambda = {
        lambda = [
            "arn:aws:lambda:eu-west-2:009831754594:function:PlaceOrder", 
            "arn:aws:lambda:eu-west-2:009831754594:function:ProcessPayment",
            "arn:aws:lambda:eu-west-2:009831754594:function:CancelOrder",
            "arn:aws:lambda:eu-west-2:009831754594:function:ConfirmOrder",
            "arn:aws:lambda:eu-west-2:009831754594:function:NotifyUser",
            "arn:aws:lambda:eu-west-2:009831754594:function:NotifyWithPolly"
            ]
    }
  }

  type = "STANDARD"

  tags = {
    Module = "pizza_orders_step_function"
  }
}