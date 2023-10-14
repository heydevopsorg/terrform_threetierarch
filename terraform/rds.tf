module "rds" {
  source            = "./modules/rds"
  subnets           = aws_subnet.private_subnets
  vpc_id            = aws_vpc.main.id
  from_sgs          = [aws_security_group.application_tier]
  allocated_storage = var.allocated_storage
  engine_version    = var.engine_version
  multi_az          = false
  db_name           = var.db_name
  db_username       = var.rds_db_admin
  db_password       = var.rds_db_password
  instance_class    = var.instance_class
  engine            = var.db_engine
}
