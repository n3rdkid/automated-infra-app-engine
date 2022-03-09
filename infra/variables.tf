variable "app_engine_initialized" {
  default     = true
  type        = bool
  description = "Has App engine been initialized once"
}

variable "default_service_source" {
  type        = string
  description = "Name of the bucket that contains source zip for default service"
}
variable "project_id" {
  type        = string
  description = "GCP project id"
}
variable "app_engine_region" {
  type        = string
  description = "The location to serve the App Engine application from"
}
variable "credentials" {
  type        = string
  description = "Path to GCP serviceAccountKey.json"
}