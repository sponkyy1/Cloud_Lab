output "role_dynamodb_arn" {
  value =  aws_dynamodb_table.this.arn
}
output "role_dynamodb_name" {
  value =  aws_dynamodb_table.this.name
}