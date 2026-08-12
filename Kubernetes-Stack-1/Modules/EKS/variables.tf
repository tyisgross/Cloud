# modules/eks/variables.tf

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "control_plane_subnet_ids" {
  type = list(string)
}