resource "aws_dynamodb_table" "orders" {
  name = "Orders"
  billing_mode = "PROVISIONED"
  read_capacity = 20
  write_capacity = 5
  hash_key = "OrderId"

  attribute {
    name = "OrderId"
    type = "N"
  }

    tags = {
    Name = "orders"
    Environment = "development"
  }
}