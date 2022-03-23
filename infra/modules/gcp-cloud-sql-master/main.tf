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
  count=   var.sql_import ? 0 : 1
  name      = var.db_name
  instance  = google_sql_database_instance.master.name
  charset   = var.db_charset
  collation = var.db_collation
}

resource "random_id" "user_password" {
  byte_length = 8
}
resource "google_sql_user" "default" {
  name     = var.user_name
  instance = google_sql_database_instance.master.name
  host     = var.user_host
  password = var.user_password == "" ? random_id.user_password.hex : var.user_password
}

resource "null_resource" "sql_import" {
  depends_on = [
    google_storage_bucket_iam_member.admin
  ]
  count=   var.sql_import ? 1 : 0
  provisioner "local-exec" {
    when    = create
    command = <<-EOT
      echo Importing SQL from the source bucket
      gcloud sql import sql master-instance-${random_id.instance_name.hex} gs://${var.sql_dump_bucket}/sql_dump.sql.gz --project=${var.project} --quiet
    EOT
  }
}

resource "null_resource" "sql_export" {
  depends_on = [
    google_storage_bucket_iam_member.admin
  ]
  triggers={
    cloud_sql_instance= "master-instance-${random_id.instance_name.hex}"
    sql_dump_bucket=var.sql_dump_bucket
    db_name=var.db_name
    project=var.project
  }
  provisioner "local-exec" {
    when = destroy
    command = <<EOT
      echo Exporting SQL to backup bucket
      gcloud sql export sql ${self.triggers.cloud_sql_instance} gs://${self.triggers.sql_dump_bucket}/sql_dump.sql.gz --database=${self.triggers.db_name} --project=${self.triggers.project}
    EOT
  }
  
}

resource "google_storage_bucket_iam_member" "admin" {
  bucket = var.sql_dump_bucket
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_sql_database_instance.master.service_account_email_address}"
}