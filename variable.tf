variable "instance_type" {
  description = "The type of instance to be created"
  type        = string
  default     = "t2.micro" 
}

variable "image_id" {
  description = "Image id which will be used to create Instance"
  type        = string
  default     = "ami-00bb6a80f01f03502" 
}

variable "zone_id" {
  description = "Image id which will be used to create Instance"
  type        = string
  default     = "Z0813984SYX1Y8GLBGC7" 
}


variable "acm_certificate" {
  description = "Certificate ID for Load Balancer"
  type        = string
  default     = "arn:aws:acm:ap-south-1:931623615406:certificate/d31cd6a5-a4e2-4159-8b99-ba2ea550166b" 
}