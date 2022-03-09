resource "google_app_engine_application" "app" {
  count       = var.app_engine_initialized ? 0 : 1
  project     = var.project_id
  location_id = var.app_engine_region
}

resource "google_storage_bucket" "static_content_bucket" {
  name                        = "${var.project_id}-appengine-static-content"
  location                    = "ASIA-SOUTH1"
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "default_node_server" {
  name   = "default_service_node.zip"
  bucket = google_storage_bucket.static_content_bucket.name
  source = "../default_service_node.zip"
}
resource "google_app_engine_standard_app_version" "default_service" {
  version_id = "v1"
  service    = "default"
  runtime    = "nodejs14"
  entrypoint {
    shell = "npm start"
  }
  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.static_content_bucket.name}/${google_storage_bucket_object.default_node_server.name}"
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
  instance_class  = "F1"
  noop_on_destroy = true
}

resource "google_app_engine_standard_app_version" "front_service" {
  version_id = "front-service-v1"
  service    = "front"
  runtime    = "nodejs14"
  entrypoint {
    shell = "npm start"
  }
  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.static_content_bucket.name}/${google_storage_bucket_object.default_node_server.name}"
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
  instance_class            = "F1"
  delete_service_on_destroy = true
}