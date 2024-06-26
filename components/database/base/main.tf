resource "random_password" "database" {
  length  = 24
  numeric = true
  upper   = true
  lower   = true
  special = false
}

resource "aws_secretsmanager_secret" "database" {
  name                    = module.database_name.name
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "database" {
  secret_id     = aws_secretsmanager_secret.database.id
  secret_string = jsonencode(local.database_secret)
}

resource "aws_db_instance" "database" {
  identifier                          = module.database_name.name
  db_name                             = "postgresql"
  username                            = "master"
  password                            = random_password.database.result
  engine                              = "postgres"
  engine_version                      = "16"
  instance_class                      = "db.t4g.micro"
  backup_retention_period             = 0
  multi_az                            = false
  allow_major_version_upgrade         = false
  auto_minor_version_upgrade          = true
  publicly_accessible                 = false
  skip_final_snapshot                 = true
  deletion_protection                 = false
  iam_database_authentication_enabled = true
  port                                = 5432
  allocated_storage                   = 20
  max_allocated_storage               = 0
}