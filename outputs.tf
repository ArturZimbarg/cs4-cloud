output "s3_bucket_name" {
  description = "Nome do bucket S3 para armazenamento de dados"
  value       = aws_s3_bucket.data_bucket.id
}

output "dynamodb_table_arn" {
  description = "ARN da tabela DynamoDB para armazenamento das rotas"
  value       = aws_dynamodb_table.route_data_table.arn
}

output "iot_endpoint" {
  description = "Endpoint para comunicação IoT"
  value       = data.aws_iot_endpoint.iot_endpoint.endpoint_address
}

output "iot_certificate_arn" {
  description = "ARN do certificado IoT para o dispositivo"
  value       = aws_iot_certificate.device_cert.arn
}
