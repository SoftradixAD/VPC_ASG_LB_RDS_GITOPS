Task: Deploy a Scalable Web Application on AWS
Objective:
    Use Terraform to create a scalable infrastructure for a web application on AWS. The infrastructure should include a load balancer, multiple EC2 instances, and an RDS PostgreSQL database.

Requirements:

    Networking:

        Create a VPC with public and private subnets across two availability zones.
        Configure an Internet Gateway and NAT Gateway for public and private subnet routing.
            
    Compute:

        Launch a minimum of two EC2 instances in an Auto Scaling Group in the private subnets.
        Use a pre-configured AMI or a startup script to install a simple web server (e.g., Nginx).

    Database:

        Deploy an RDS PostgreSQL instance in the private subnet.
        Ensure the database is only accessible from the EC2 instances.
        
    Load Balancer:

        Set up an Application Load Balancer (ALB) in the public subnets to distribute traffic to the EC2 instances.


    Security:

        Create Security Groups to allow:
        HTTP/HTTPS traffic to the ALB.
        EC2 instances to communicate with the RDS instance on the PostgreSQL port.
        Restrict all other traffic.


    Outputs:

        Output the ALB DNS name.
        Output the RDS endpoint.