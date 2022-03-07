# Access and secret keys to your environment
#variable "access_key" {}
#variable "secret_key" {}

# security VPC
variable "sec_vpc_cidr" {
  description = "Provide the network CIDR for the VPC"
  default     = "10.0.0.0/16"
}
#### firewall subnet
variable "firewall_vpc_subnet" {
  description = "Provide the network CIDR for the firewall subnet"
  default     = "10.0.1.0/24"
}
#### protected subnet
variable "protected_vpc_subnet" {
  description = "Provide the network CIDR for the prodected subnet"
  default     = "10.0.2.0/24"
}
variable "instance_type" {
  description = "firewall instance type available sizes: \n t2.small\n t3.small\nt3.large\nm5.large\nm5.xlarge\nm5.2xlarge\nc5.large\nc5.xlarge\nc5.2xlarge"
  default     = "t2.small"
}

variable "availability_zone" {
  description = "firewall instance availability zone"
  default     = "us-east-1a"
}

variable "CC_IP" {
  description = "CC Point of Entry"
  type        = string
}
variable "Range_ID" {
  description = "CC Range ID"
  type        = string
}
variable "Cluster_Name" {
  description = "CC Cluster Name"
  type        = string
}
variable "Box_Name" {
  description = "Box Name"
  type        = string
}
variable "SharedKey" {
  description = "PAR File Retrieval Shared Key"
  type        = string
}