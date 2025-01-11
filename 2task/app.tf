resource "google_compute_instance_template" "app_template" {
  
  name_prefix  = "app-instance-template-"
  machine_type = "e2-micro"

  disk {
    auto_delete  = true
    boot         = true
    source_image = "ubuntu-os-cloud/ubuntu-2004-lts"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("username.pub")}"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.app_subnet.id
  }
  tags = ["app"]

  metadata_startup_script = <<-EOT
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nginx
  EOT

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "app_mig" {
  name               = "app-managed-instance-group"
  base_instance_name = "app-instance"
  region             = var.region
  target_size        = var.number_of_instances_app

  version {
    instance_template = google_compute_instance_template.app_template.id
  }

  lifecycle {
    prevent_destroy = false
  }
}

