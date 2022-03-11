resource "random_id" "instance_name" {
  byte_length = 2
}
resource "google_sql_database_instance" "master" {
  # After a name is used, it cannot be reused for up to one week.
  name                 = "master-instance-${random_id.instance_name.hex}"
  # Cloud SQL is not available in all regions
  region               = var.database_instance_region
  database_version     = var.database_version

  master_instance_name = var.master_instance_name
  # Manually update deletion protection to prevent accidental deletion
  deletion_protection=false
  settings {
    tier                        = var.tier
    # When the instance should be active
    activation_policy           = var.activation_policy
    # authorized_gae_applications = var.authorized_gae_applications
    dynamic "backup_configuration" {
      for_each = [var.backup_configuration]
      content {

        binary_log_enabled = lookup(backup_configuration.value, "binary_log_enabled", null)
        enabled            = lookup(backup_configuration.value, "enabled", null)
        start_time         = lookup(backup_configuration.value, "start_time", null)
      }
    }

    disk_size        = var.disk_size
    disk_type        = var.disk_type
  }
}

resource "google_sql_database" "default" {
  name      = var.db_name
  instance  = google_sql_database_instance.master.name
  charset   = var.db_charset
  collation = var.db_collation
}

resource "random_id" "user_password" {
  byte_length = 8
}
resource "google_sql_user" "default" {
  # count    = var.master_instance_name == "" ? 1 : 0
  name     = var.user_name
  instance = google_sql_database_instance.master.name
  host     = var.user_host
  password = var.user_password == "" ? random_id.user_password.hex : var.user_password
}