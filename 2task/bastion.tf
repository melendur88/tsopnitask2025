# bastion.tf - Bastion Host
resource "google_compute_instance" "bastion" {
  name         = "bastion-host"
  machine_type = "e2-micro"
  zone         = "europe-west1-b"

  deletion_protection = false

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork   = google_compute_subnetwork.app_subnet.id
    access_config {}
  }

  tags = ["bastion"]

  metadata = {
    ssh-keys = "ubuntu:${file("username.pub")}"
    #serial-port-enable = TRUE
}
}
