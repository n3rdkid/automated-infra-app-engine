variable "app_engine_initialized" {
  type        = bool
  description = "Has App engine been initialized once"
}
variable "project" {
  type        = string
  description = "GCP project id"
}

variable "app_engine_region" {
  type        = string
  description = "The location to serve the App Engine application from"
}