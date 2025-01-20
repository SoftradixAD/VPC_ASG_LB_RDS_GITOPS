resource "aws_db_instance" "postgres_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "13.4"  # Specify the version you want
  instance_class       = "db.t3.micro"  # Choose instance size
  db_name              = "mydb"
  username             = jsondecode(aws_secretsmanager_secret_version.db_credentials_version.secret_string).username
  password             = jsondecode(aws_secretsmanager_secret_version.db_credentials_version.secret_string).password
  parameter_group_name = "default.postgres13"  # Default parameter group for PostgreSQL 13
  multi_az             = false
  publicly_accessible  = false
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.postgres_sg.id]

  tags = {
    Name = "MyPostgresDB"
  }
}

output "db_endpoint" {
  value = aws_db_instance.postgres_db.endpoint
}

output "db_instance_id" {
  value = aws_db_instance.postgres_db.id
}

output "db_password" {
  value = random_password.db_password.result  # Output the generated password (optional)
  sensitive = true
}