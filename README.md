# pizza-orders
Serverless Demo Architecture from CloudAcademy built up in Terraform
CloudAcademy Course: https://app.qa.com/course/advanced-use-of-amazon-api-gateway
The Cloud Academy course is a clickops exercise. 

This project attempts to do the course using Terraform code and with that offer some
value to get some basic templates in a repo on how to implement API Gateway - Step functions - Lambdas with Lambda code and web application hosted in S3.

## Development

### Storage

#### DynamoDB

Add the DynamoDB Orders table

cd storage/dynamodb
terraform init
terraform apply

#### S3

Add the S3 bucket to store the Lambda code
Upload the 3.4Kb LambdaFunctions.zip manually in the AWS Console to S3 overriding the 0Kb size placeholder.

cd storage/s3
terraform init
terraform apply

### Compute

#### Lambda

The Lambdas follow the process as per this workflow:

Add the S3 bucket location from output to the Lambda variable bucket_prefix:

variable "bucket_prefix" {
  type = string
  description = "The prefix to use for the s3 bucket name"
  default = "xxxx"
}

cd compute/lambda
terraform init
terraform apply

#### Step Function

Create the step function that use the lambda code

cd compute/stepfunction
terraform init
terraform apply

### Networking

Create the role/APIGatewayToStepFunctions

#### API Gateway Execution Role

Will be created as part of API Gateway step

#### API Gateway

Set up API Gateway against the step function

cd networking/api-gateway
terraform init
terraform apply

### Ordering Web Site

Manually generate and download from API Gateway AWS Console the NodeJS client SDK
example/pizzaorders-app/apiGateway-js-sdk

Set up the ordering web application, download the zip file from here:
https://github.com/cloudacademy/advanced-api-gateway-resources

Update in the goPizza.html the state machine arn in line 200 to your state machine arn

Manually upload the examples/pizzaorders-app lib folder and goPizza.html, apigClientjs to the S3 bucket created earlier.

Apply web hosting to the s3 bucket in Terraform configuration

#### Polly voice

In the file storage/s3/LambdaFunctions/NotifyWithPolly.js add the s3 bucket URL, zip the file and upload the LambdaFunctions.zip manually to s3

var uploadParams = { Bucket: "pacator-gopizza-lambda-functions20230315153525618700000001"

## Test

In order to test the step function in the AWS console you can add a sample:

{
    "orderid": 9,
    "customerid": "cus_9",
    "ordertype": "Pickup",
    "ordertotal": 14,
    "orderitem1": "Pizza",
    "orderitem2": "Garlic Dough balls",
    "orderitem3": "Tuna Salad",
    "orderitem4": "Vino rosso",
    "paymenttype": "CreditCard",
    "cardnumber": "1111111111111111",
    "cardname": "Tina Fey",
    "zipcode": "678",
    "securitycode": "123"
}

To test API Gateway POST to state machine:

{
  "input": "{\"orderid\": \"19\",\"customerid\": \"12\",\"ordertype\": \"pickup\",\"ordertotal\": \"15.75\",\"orderitem1\": \"pizza\",\"orderitem2\": \" \",\"paymenttype\": \"creditcard\",\"cardnumber\": \"1111111111111111\",\"cardname\": \"Tina Fey\",\"zipcode\": \"678\",\"securitycode\": \"123\"}",
   "name": "MyExec-2-31",
   "stateMachineArn": "arn:aws:states:eu-west-2:009831754594:stateMachine:pizza-orders-step-function"
}









