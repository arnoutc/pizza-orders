output "api-gateway-url" {
  value = "${aws_api_gateway_deployment.step-api-gateway-deployment.invoke_url}/startStepFunctions"
}