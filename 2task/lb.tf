resource "google_compute_forwarding_rule" "http_forwarding_rule" {
  name        = "http-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  target      = google_compute_target_http_proxy.http_proxy.id
  port_range  = "80"
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name   = "http-proxy"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_url_map" "default" {
  name            = "default-url-map"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_backend_service" "default" {
  name                  = "default-backend-service"
  load_balancing_scheme = "EXTERNAL"
  protocol              = "HTTP"
  timeout_sec           = 10

  backend {
    group = google_compute_region_instance_group_manager.api_mig.instance_group
  }

  health_checks = [google_compute_health_check.default.id]
}

resource "google_compute_health_check" "default" {
  name = "http-health-check"

  http_health_check {
    request_path = "/"
    port         = 80
  }
}
