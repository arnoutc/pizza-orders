output "table_name" {
  value       = aws_dynamodb_table.orders.name
  description = "DynamoDB table name"
}