resource "aws_glue_catalog_database" "database" {
  name  = "${var.prefix}-glue-database"
}