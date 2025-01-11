# security-groups.tf - Security Groups
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0", "35.235.240.0/20"]
  target_tags   = ["bastion"]
  description   = "Allow SSH access to bastion host"
}

resource "google_compute_firewall" "allow_ssh_from_bastion" {
  name    = "allow-ssh-from-bastion"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["192.168.1.0/27"]
  target_tags   = ["app", "api"]
  description   = "Allow SSH traffic from bastion to other instances"
}

resource "google_compute_firewall" "allow_icmp" {
  name    = "allow-icmp"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  description   = "Allow ICMP traffic"
}
resource "google_compute_firewall" "allow_lb_http_https" {
  name    = "allow-lb-http-https"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["lb"]
  description   = "Allow HTTP/HTTPS traffic to load balancer"
}

