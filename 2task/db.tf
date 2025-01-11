resource "google_sql_database_instance" "primary_db" {
  name             = "primary-db"
  database_version = "POSTGRES_13"
  region           = var.region

  settings {
    tier = "db-f1-micro"
    availability_type = "REGIONAL" # Dla wysokiej dostępności
    #backup_configuration {
    #  enabled = true          # hashed for me - dont want to take the cost :)
    }
  }

  deletion_protection = false
}

resource "google_sql_user" "root_user" {
  name     = "root"
  instance = google_sql_database_instance.primary_db.name
  password = "password123"
}

resource "google_sql_database" "primary_database" {
  name     = "app_database"
  instance = google_sql_database_instance.primary_db.name
}

resource "google_sql_database_instance" "read_replica" {
  name               = "read-replica-db"
  database_version   = "POSTGRES_13"
  region             = var.region
  master_instance_name = google_sql_database_instance.primary_db.name

  settings {
    tier = "db-f1-micro"
    availability_type = "REGIONAL"
  }

  deletion_protection = false
}
