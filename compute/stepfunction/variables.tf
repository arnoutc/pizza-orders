variable "region" {
  type = string
  description = "The AWS region name to create/manage the resource in"
  default = "eu-west-2"
}

variable "place-order" {
  type = string
  description = "The step function for PlaceOrder"
  default = "arn:aws:lambda:eu-west-2:009831754594:function:PlaceOrder"
}

variable "process-payment" {
  type = string
  description = "The step function for ProcessPayment"
  default = "arn:aws:lambda:eu-west-2:009831754594:function:ProcessPayment"
}

variable "confirm-order" {
  type = string
  description = "The step function for ConfirmOrder"
  default = "arn:aws:lambda:eu-west-2:009831754594:function:ConfirmOrder"
}

variable "cancel-order" {
  type = string
  description = "The step function for CancelOrder"
  default = "arn:aws:lambda:eu-west-2:009831754594:function:CancelOrder"
}

variable "notify-user" {
  type = string
  description = "The step function for NotifyUser"
  default = "arn:aws:lambda:eu-west-2:009831754594:function:NotifyUser"
}

variable "notify-with-polly" {
  type = string
  description = "The step function for NotifyWithPolly"
  default = "arn:aws:lambda:eu-west-2:009831754594:function:NotifyWithPolly"
}