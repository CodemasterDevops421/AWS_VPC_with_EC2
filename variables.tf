variable "location" {
  default = "ap-south-1"
}

variable "os_name" {
  default = "ami-006935d9a6773e4ec"
}

variable "key" {
  default = "demo-03"
}

variable "instance-type" {
  default = "t2.micro"
}

variable "vpc-cidr" {
  default = "10.0.0.0/16"
}

variable "subnet1-cidr" {
  default = "10.0.1.0/24"

}
variable "subent_az" {
  default = "ap-south-1a"
}
