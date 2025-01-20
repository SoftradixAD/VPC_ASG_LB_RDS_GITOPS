# Create the secret in Secrets Manager
resource "aws_secretsmanager_secret" "db_credentials" {
  description = "Credentials for PostgreSQL RDS instance"

  tags = {
    Name = "mydb-credentials"
  }
}

# Generate a random password for the database
resource "random_password" "db_password" {
  length  = 16
  special = true
  upper   = true
  lower   = true
  numeric  = true
}

# Store the username and password as key-value pairs in the secret
resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "akshay"
    password = random_password.db_password.result 
  })
}