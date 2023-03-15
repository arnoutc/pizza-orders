resource "aws_api_gateway_rest_api" "api-gateway-for-stepFunc" {
  name        = "StepFuncAPI"
  description = "API to access step functions workflow"
  body        = "${data.template_file.step_api_swagger.rendered}"
}

data "template_file" step_api_swagger{
  template = "${file("StepFunctionsAPI-test-swagger.yml")}"
}

resource "aws_api_gateway_deployment" "step-api-gateway-deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.api-gateway-for-stepFunc.id}"
  stage_name  = "dev"
}

