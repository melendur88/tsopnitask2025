## Description
This Terraform project showcases a sample environment for GCP but from logical perspective architecture cane be recreate in AWS/Openstack or Azure changing of course resources. The project focuses on examples of using High Availability (HA) mechanisms, scalability, and security. 

The infrastructure is designed as a practical showcase of capabilities, with examples of key configurations. While functional, this is a sample environment intended for illustrative purposes rather than production use.

I do not use f.ex in db.conf passwords managers - but should be done if this will be a production or customer enviroments with sensisitive data.

---

## File Structure
- **`main.tf`**: Configuration for the provider and global variables.
- **`network.tf`**: Creates the VPC, subnets, and NAT.
- **`app.tf`**: Configures Managed Instance Group (MIG) for the app servers.
- **`api.tf`**: Configures Managed Instance Group (MIG) for the API servers.
- **`db.conf`**: Sets up Cloud SQL with a primary database and a read replica.
- **`security-groups.tf`**: Defines firewall rules for SSH, HTTP/HTTPS, ICMP, and inter-instance communication.
- **`loadbalancer.tf`**: Configures an HTTP/HTTPS Load Balancer.
- **`monitoring.tf`**: Monitoring and notification setup for instance states (e.g., errors, shutdowns).
- **`terraform.tfvars`**: Default variable values for the environment.
---
