# Create a security group
resource "aws_security_group" "main_instance_sg" {
  name_prefix = "instance-sg"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance
resource "aws_instance" "main_instance" {
  ami           = "ami-00bb6a80f01f03502" # Amazon Linux 2 AMI (update as needed)
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  subnet_id     = aws_subnet.private.id
  key_name      = "softradixad"
  vpc_security_group_ids = [aws_security_group.main_instance_sg.id]
  root_block_device {
    volume_size = 10
    volume_type = "gp3"
    delete_on_termination = true
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y mysql-client jq
              snap install aws-cli --classic

              # Retrieve MySQL credentials from Secrets Manager
              SECRET_NAME="rds_mysql_credentials"
              REGION="ap-south-1"
              SECRET=$(aws secretsmanager get-secret-value --secret-id $SECRET_NAME --region $REGION --query SecretString --output text)

              MYSQL_USER=$(echo $SECRET | jq -r .username)
              MYSQL_PASSWORD=$(echo $SECRET | jq -r .password)

              # Export environment variables
              echo "export MYSQL_USER=$MYSQL_USER" >> /etc/profile
              echo "export MYSQL_PASSWORD=$MYSQL_PASSWORD" >> /etc/profile

              # Source the profile to set environment variables
              source /etc/profile
              EOF
  
  tags = {
    Name = "Main Instance"
  }

  lifecycle {
    create_before_destroy = true  # Force recreation of the instance
  }
}
