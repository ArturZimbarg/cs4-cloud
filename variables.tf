# Região da AWS
variable "aws_region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

# Nome do bucket S3 para dados
variable "s3_bucket_name" {
  description = "Nome do bucket S3 para armazenamento de dados"
  type        = string
  default     = "meu-bucket-dados"
}

# Nome do bucket S3 para arquivos de áudio (caso precise no futuro)
variable "audio_bucket_name" {
  description = "Nome do bucket S3 para armazenamento de arquivos de áudio"
  type        = string
  default     = "meu-bucket-audio"
}

# Nome da tabela DynamoDB
variable "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB para armazenamento das rotas do usuário"
  type        = string
  default     = "RouteDataTable"
}

# Nome do dispositivo IoT (Thing)
variable "iot_thing_name" {
  description = "Nome do dispositivo IoT (Thing)"
  type        = string
  default     = "SmartGlasses"
}

# Nome da política IoT
variable "iot_policy_name" {
  description = "Nome da política IoT"
  type        = string
  default     = "SensorDataPolicy"
}

# Nome da função Lambda (caso futuro)
variable "lambda_function_name" {
  description = "Nome da função Lambda"
  type        = string
  default     = "PollyTextToSpeechFunction"
}
outputs.tf
Esse arquivo outputs.tf exibe saídas importantes, como o ARN da tabela DynamoDB, o nome do bucket S3 e o endpoint IoT para facilitar o acesso a esses recursos após a criação.

hcl
Copiar código
# Exibe o nome do bucket S3 para dados
output "s3_bucket_name" {
  description = "Nome do bucket S3 para armazenamento de dados"
  value       = aws_s3_bucket.data_bucket.id
}

# Exibe o ARN da tabela DynamoDB
output "dynamodb_table_arn" {
  description = "ARN da tabela DynamoDB para armazenamento das rotas"
  value       = aws_dynamodb_table.route_data_table.arn
}

# Exibe o endpoint IoT
output "iot_endpoint" {
  description = "Endpoint para comunicação IoT"
  value       = data.aws_iot_endpoint.iot_endpoint.endpoint_address
}
