resource "google_monitoring_notification_channel" "email_channel" {
  display_name = "Email Notifications"
  type         = "email"
  labels = {
    email_address = var.notification_email
  }
}

resource "google_monitoring_alert_policy" "instance_error_state" {
  display_name = "Instance Error State Alert"

  conditions {
    display_name = "VM Instance Error State"
    condition_threshold {
      filter          = "metric.type=\"compute.googleapis.com/instance/uptime\" resource.type=\"gce_instance\""
      duration        = "300s"
      comparison      = "COMPARISON_LT"
      threshold_value = 1
    }
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]
}

resource "google_monitoring_alert_policy" "instance_shutdown" {
  display_name = "Instance Shutdown Alert"

  conditions {
    display_name = "VM Instance Shutdown"
    condition_threshold {
      filter          = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\""
      duration        = "300s"
      comparison      = "COMPARISON_EQ"
      threshold_value = 0
    }
  }

  notification_channels = [google_monitoring_notification_channel.email_channel.id]
}
