data "google_client_config" "current" {}

variable "project" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "europe-west1"
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "custom-vpc"
}

variable "ip_cidr_range_app" {
  description = "CIDR range for the app subnet"
  type        = string
  default     = "192.168.1.0/27"
}

variable "ip_cidr_range_api" {
  description = "CIDR range for the api subnet"
  type        = string
  default     = "192.168.1.32/27"
}

variable "ip_cidr_range_db" {
  description = "CIDR range for the database subnet"
  type        = string
  default     = "192.168.1.64/27"
}

variable "number_of_instances_api" {
  description = "Number of API instances to create"
  type        = number
  default     = 2
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = "europe-west1-b"
}

