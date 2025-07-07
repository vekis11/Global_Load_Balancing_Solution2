# GCP Global Load Balancing Solution

This project demonstrates a global load balancing solution using Google Cloud Platform (GCP) services:

- **Cloud Load Balancing**
- **Compute Engine**
- **Cloud CDN**
- **Terraform**
- **Docker**

## Architecture Overview

- Multiple Compute Engine instances are deployed across different regions.
- Docker is used to containerize the application.
- Cloud Load Balancer distributes traffic globally and performs health checks.
- Cloud CDN accelerates content delivery.
- Infrastructure is managed as code using Terraform.

## Getting Started

1. Build and push the Docker image.
2. Deploy infrastructure with Terraform.
3. Access your globally load-balanced application.

---

See `main.tf` for Terraform configuration and `docker/` for the sample Docker app. 