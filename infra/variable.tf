variable "ec2_instance_type" {
  default = "t3.small"
  type    = string
}

variable "az" {
  default = "ap-south-1a"
  type    = string
}

variable "ec2_ami_id" {
  default = "ami-051a31ab2f4d498f5"
  type    = string
}

variable "app_name" {
  default = "taskflow"
  type    = string
}