# Create a DB Subnet Group for the RDS instance
resource "aws_db_subnet_group" "postgres_subnet_group" {
  name        = "my-postgres-subnet-group"
  description = "Subnet group for PostgreSQL RDS instance"
  subnet_ids  = [ aws_subnet.private.id, aws_subnet.private2.id ]  # Use the subnets from the default VPC

  tags = {
    Name = "MyPostgresSubnetGroup"
  }
}

data "aws_secretsmanager_secret" "db_credentials" {
  name = aws_secretsmanager_secret.db_credentials.name
}

data "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = data.aws_secretsmanager_secret.db_credentials.id
}


resource "aws_db_instance" "postgres_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "16"  # Specify the version you want
  instance_class       = "db.t3.micro"  # Choose instance size
  db_name              = "mydb"
  username             = jsondecode(data.aws_secretsmanager_secret_version.db_credentials_version.secret_string)["username"]
  password             = jsondecode(data.aws_secretsmanager_secret_version.db_credentials_version.secret_string)["password"]
  parameter_group_name = "default.postgres16"  # Default parameter group for PostgreSQL 13
  multi_az             = false
  publicly_accessible  = false
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.postgres_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.postgres_subnet_group.name
#   parameter_group_name        = aws_db_parameter_group.education.name

  tags = {
    Name = "MyPostgresDB"
  }
}

