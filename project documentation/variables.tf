variable "var1" {
  type        = string
  description = "CIDR for the VPC"
  default     = "10.1.0.0/20"
}

variable "key_name" {
  description = "Name of keypair to ssh"
  default="labkp1"
}