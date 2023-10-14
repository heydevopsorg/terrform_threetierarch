variable "db_username" {
  type = string
}
variable "db_password" {
  type = string
}

variable "multi_az" {
  type = bool
}

variable "db_name" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(any)
}

variable "from_sgs" {
  type = list(any)
}

variable "instance_class" {
  type = string
}

variable "engine" {
  type = string
}