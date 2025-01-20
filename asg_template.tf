resource "aws_iam_instance_profile" "instance_profile" {
  name = "prod_instance_profile"
  role = aws_iam_role.ssm_role.name
}

# Create a launch template
resource "aws_launch_template" "launch_template" {
  name_prefix   = "prod-launch-template-"
  description   = "Prod Launch Template"
  
  instance_type          = var.instance_type
  image_id               = var.image_id  # Specify your desired AMI ID
  key_name               = "prod-key"  # Specify the name of your EC2 key pair
  
  #security_groups	 = [aws_security_group.prod.id] 
  
  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }

  block_device_mappings {
    device_name = "/dev/sda1" 
    ebs {
      volume_type           = "gp3"
      volume_size           = 10
      delete_on_termination = true
    }
  }

  network_interfaces {
    security_groups             = [ aws_security_group.instance_sg.id ]
  } 
  
  user_data = base64encode(<<-EOF
    #!/bin/bash
    #installing docker
    apt-get update

    apt install nginx -y
    apt install postgresql-client -y
  EOF
)

  tags = {
    Name = "ProdLaunchTemplate"
  }
}