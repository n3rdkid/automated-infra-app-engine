module "cloud_sql_master" {
  source          = "./modules/gcp-cloud-sql-master"
  sql_import      = var.sql_import
  sql_dump_bucket = var.sql_dump_bucket
  project = var.project
}


module "app_engine" {
  source                 = "./modules/gcp-app-engine-services"
  app_engine_initialized = var.app_engine_initialized
  project                = var.project
  app_engine_region      = var.app_engine_region
}