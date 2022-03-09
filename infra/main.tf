resource "google_app_engine_application" "app" {
  count       = var.app_engine_initialized ? 0 : 1
  project     = var.project_id
  location_id = var.app_engine_region
}

resource "google_app_engine_standard_app_version" "default_service" {
  version_id = "v1"
  service    = "default"
  runtime    = "nodejs14"
  entrypoint {
    shell = "node ./app.js"
  }
  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${var.default_service_source}/default_service.zip"
    }
  }
 automatic_scaling {
    min_idle_instances = 0
    max_idle_instances = 1
    
    standard_scheduler_settings {
      min_instances = 0
      max_instances = 1
    }
  }
  instance_class="F1"
  noop_on_destroy = true
}