# Provider AWS
provider "aws" {
  region = var.aws_region
}

# Configuração de um dispositivo IoT (Thing)
resource "aws_iot_thing" "sensor_device" {
  name = "SmartGlasses"
}

# Certificado para autenticar o dispositivo Thing
resource "aws_iot_certificate" "device_cert" {
  active = true
}

# Política de permissão para o dispositivo
resource "aws_iot_policy" "device_policy" {
  name = "SensorDataPolicy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "iot:Publish",
        "iot:Receive",
        "iot:Connect",
        "iot:Subscribe"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Associa o certificado com a política de IoT
resource "aws_iot_policy_attachment" "device_policy_attach" {
  policy = aws_iot_policy.device_policy.name
  target = aws_iot_certificate.device_cert.arn
}

# Amazon DynamoDB para armazenar rotas/mapas
resource "aws_dynamodb_table" "route_data_table" {
  name           = var.dynamodb_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "user_id"
  range_key      = "route_id"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "route_id"
    type = "S"
  }

  tags = {
    Name        = "RouteDataTable"
    Environment = "Dev"
  }
}

# Regra de Tópico IoT que envia dados para o DynamoDB
resource "aws_iot_topic_rule" "sensor_data_rule" {
  name        = "SensorDataRule"
  sql         = "SELECT * FROM 'sensors/inertial'"
  sql_version = "2016-03-23"

  dynamodb {
    table_name = aws_dynamodb_table.route_data_table.name
    role_arn   = aws_iam_role.iot_dynamo_access.arn
  }
}

# Endpoint para comunicação
data "aws_iot_endpoint" "iot_endpoint" {
  endpoint_type = "iot:Data-ATS"
}

# Função de IAM necessária para IoT acessar DynamoDB
resource "aws_iam_role" "iot_dynamo_access" {
  name = "IotDynamoAccessRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "iot.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  inline_policy {
    name = "IotDynamoPolicy"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:GetItem"
      ],
      "Resource": "${aws_dynamodb_table.route_data_table.arn}"
    }
  ]
}
EOF
  }
}

# Amazon S3 Bucket para armazenar dados de arquivos
resource "aws_s3_bucket" "data_bucket" {
  bucket = var.s3_bucket_name
  acl    = "private"

  tags = {
    Name        = "DataStorageBucket"
    Environment = "Dev"
  }
}

# Definindo política de bucket para permitir acesso seguro ao bucket
resource "aws_s3_bucket_policy" "data_bucket_policy" {
  bucket = aws_s3_bucket.data_bucket.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "${aws_s3_bucket.data_bucket.arn}/*"
    }
  ]
}
EOF
}
