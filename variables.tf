variable "aws_region" {
  description = "Region where ami-0eec78ea4cbaaf5bd and sg-00e79a3a2a694b395 exist. AMI and security group IDs are regional."
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "m6a.xlarge"
}

variable "ami_id" {
  description = "AMI for the Kind host."
  type        = string
  default     = "ami-0eec78ea4cbaaf5bd"
}

variable "security_group_id" {
  description = "Existing security group. It must allow inbound SSH (tcp/22) from the machine running Terraform."
  type        = string
  default     = "sg-00e79a3a2a694b395"
}

variable "subnet_id" {
  description = "Subnet in the security group VPC. Leave null to use the first subnet that auto-assigns a public IPv4 address. The subnet must route to an internet gateway so SSH and package downloads work."
  type        = string
  default     = null
}

variable "ssh_user" {
  description = "SSH user for the remote-exec provisioner."
  type        = string
  default     = "ec2-user"
}

variable "ssh_password" {
  description = "SSH password set for ssh_user before remote-exec connects."
  type        = string
  default     = "DevOps321"
  sensitive   = true
}

variable "root_volume_size_gb" {
  description = "Root volume size. Kind node images need more than the AMI default."
  type        = number
  default     = 40
}

variable "kind_cluster_name" {
  description = "Name of the Kind cluster created after boot."
  type        = string
  default     = "kind"
}
