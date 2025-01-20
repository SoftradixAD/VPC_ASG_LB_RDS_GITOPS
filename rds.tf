# Create a security group for RDS
resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-sg"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.main_instance_sg.id]  # Update this to restrict access if needed
  }
}


resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "rds-subnet-group"
  subnet_ids  = [aws_subnet.private.id, aws_subnet.private2.id]
  description = "RDS subnet group"
}


data "aws_secretsmanager_secret_version" "rds_credentials_version" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id
}


resource "aws_db_instance" "mysql_instance" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"  # Choose the instance type based on your requirements
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  multi_az             = false 
  publicly_accessible  = false 
  skip_final_snapshot  = true

  username      = "admin"
  password      = jsondecode(data.aws_secretsmanager_secret_version.rds_credentials_version.secret_string)["password"]

  
}
