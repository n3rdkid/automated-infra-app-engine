variable "database_instance_region" {
  description = "Region for cloud resources"
  default     = "asia-southeast2"
}

variable "database_version" {
  description = "The version of of the database. For example, `MYSQL_5_6` or `POSTGRES_9_6`."
  default     = "MYSQL_8_0"
}

variable "master_instance_name" {
  description = "The name of the master instance to replicate"
  default     = ""
}

variable "tier" {
  description = "The machine tier (First Generation) or type (Second Generation). See this page for supported tiers and pricing: https://cloud.google.com/sql/pricing"
  default     = "db-f1-micro"
}

variable "db_name" {
  description = "Name of the default database to create"
  default     = "default_db"
}

variable "db_charset" {
  description = "The charset for the default database"
  default     = "utf8mb4"
}

variable "db_collation" {
  description = "The collation for the default database. Example for MySQL databases: 'utf8_general_ci', and Postgres: 'en_US.UTF8'"
  default     = "utf8mb4_general_ci"
}

variable "user_name" {
  description = "The name of the default user"
  default     = "admin"
}

variable "user_host" {
  description = "The host for the default user"
  default     = "%"
}

variable "user_password" {
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  default     = "12345678"
}

variable "activation_policy" {
  description = "This specifies when the instance should be active. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  default     = "ALWAYS"
}

variable "authorized_gae_applications" {
  description = "A list of Google App Engine (GAE) project names that are allowed to access this instance."
  default     = []
}

variable "disk_size" {
  description = "Second generation only. The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased."
  default     = 10
}

variable "disk_type" {
  description = "Second generation only. The type of data disk: `PD_SSD` or `PD_HDD`."
  default     = "PD_SSD"
}

variable "backup_configuration" {
  description = "The backup_configuration settings subblock for the database setings"
  default     = {
    binary_log_enabled = true
    enabled=true
  }
}
variable "sql_import" {
  type        = bool
  description = "Should we import during creation"
}

variable "sql_dump_bucket" {
  type        = string
  description = "Name of the bucket where sql is dumped"
}

variable "project" {
  type        = string
  description = "GCP project id"
}