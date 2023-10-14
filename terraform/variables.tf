variable "region" {
}

variable "main_cidr_block" {
  type    = string
}

variable "public_cidr_blocks" {
  type    = list(string)
}


variable "private_cidr_blocks" {
  type    = list(string)
}

variable "ecr_application_tier" {
  type    = string
}

variable "ecr_presentation_tier" {
  type    = string
}

# rds variables
variable "rds_db_admin" {
}

variable "rds_db_password" {
}

variable "multi_az" {
}

variable "db_name" {
}

variable "engine_version" {
}

variable "allocated_storage" {
}

variable "instance_class" {
}

variable "db_engine" {
}
