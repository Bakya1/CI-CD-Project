variable "var1" {
  type        = string
  description = "CIDR for the VPC"
  default     = ""
}

variable "key_name" {
  description = "Name of keypair to ssh"
  default="labkp1"
}
