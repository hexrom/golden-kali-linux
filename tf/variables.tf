variable "region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "The AMI ID of the Packer-created Kali Linux instance"
  type        = string
  default     = "ami-06d6f09e9ccc7fce1"
}

variable "instance_type" {
  description = "The type of EC2 instance to create"
  type        = string
  default     = "t2.medium"
}

variable "key_name" {
  description = "The name of the key pair to attach to the EC2 instance"
  type        = string
  default     = "prodlabs"
}
