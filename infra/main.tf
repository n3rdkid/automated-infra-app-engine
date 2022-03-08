resource "google_app_engine_application" "app" {
  count       = var.app_engine_initialized ? 0 : 1
  project     = var.project_id
  location_id = var.app_engine_region
}