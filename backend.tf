terraform {
  backend "s3" {
    bucket         = "local-dropbox-backup-india"
    key            = "local-dropbox-backup-india/state/gitops/terraform.tfstate" 
    region         = "ap-south-1"
    encrypt        = true                        
  }
}
