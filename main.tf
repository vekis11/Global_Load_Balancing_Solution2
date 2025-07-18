provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_instance_template" "default" {
  name         = "app-template-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
  machine_type = var.machine_type
  region       = var.region

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = <<-EOT
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo gcloud auth configure-docker us-central1-docker.pkg.dev --quiet
    sudo docker run -d -p 80:80 us-central1-docker.pkg.dev/${var.project_id}/sample-repo/sample-app:latest
  EOT
}

resource "google_compute_instance_group_manager" "default" {
  name               = "app-mig-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
  base_instance_name = "app-instance"
  zone               = "${var.region}-a"
  version {
    instance_template = google_compute_instance_template.default.id
  }
  target_size = var.instance_count
  auto_healing_policies {
    health_check      = google_compute_health_check.default.id
    initial_delay_sec = 300
  }
}

resource "google_compute_health_check" "default" {
  name               = "app-health-check-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
  http_health_check {
    port = 80
  }
}

resource "google_compute_backend_service" "default" {
  name                  = "app-backend-service-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 10
  health_checks         = [google_compute_health_check.default.id]
  enable_cdn            = true
  backend {
    group = google_compute_instance_group_manager.default.instance_group
  }
}

resource "google_compute_url_map" "default" {
  name            = "app-url-map-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_target_http_proxy" "default" {
  name   = "app-http-proxy-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = "app-forwarding-rule-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
  target                = google_compute_target_http_proxy.default.id
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL"
  ip_protocol           = "TCP"
} 
