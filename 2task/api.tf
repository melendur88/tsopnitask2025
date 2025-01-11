resource "google_compute_instance_template" "api_template" {
  
  name_prefix  = "api-instance-template-"
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
    subnetwork = google_compute_subnetwork.api_subnet.id
  }
  tags = ["api"]

  metadata_startup_script = <<-EOT
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nginx
  EOT

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "api_mig" {
  name               = "api-managed-instance-group"
  base_instance_name = "api-instance"
  region             = var.region
  target_size        = var.number_of_instances_api

  version {
    instance_template = google_compute_instance_template.api_template.id
  }

  lifecycle {
    prevent_destroy = false
  }
}

