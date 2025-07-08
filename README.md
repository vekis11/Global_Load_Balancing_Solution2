# Global Load Balancing Solution using Google Cloud Platform

**Author:** Vekis Tem

## Project Overview

This project implements a comprehensive global load balancing solution using Google Cloud Platform (GCP) services. The solution provides high availability, scalability, and global content delivery for web applications through a multi-region deployment architecture.

### Key Features

- 🌍 **Global Load Balancing**: Distributes traffic across multiple regions for optimal performance
- 🚀 **Auto-scaling**: Managed Instance Groups automatically scale based on demand
- 🏥 **Health Monitoring**: Continuous health checks ensure only healthy instances receive traffic
- ⚡ **Content Delivery**: Cloud CDN accelerates content delivery worldwide
- 🐳 **Containerized**: Docker-based application deployment
- 🏗️ **Infrastructure as Code**: Complete Terraform automation for deployment

## Architecture

### High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    Global Load Balancer                         │
│                    (Single IP Address)                          │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Cloud CDN                                    │
│              (Content Delivery Network)                         │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Backend Service                              │
│              (Health Checks & Load Distribution)                │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│              Managed Instance Group                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │ Instance 1  │  │ Instance 2  │  │ Instance N  │              │
│  │ (Docker)    │  │ (Docker)    │  │ (Docker)    │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
└─────────────────────────────────────────────────────────────────┘
```

### Component Details

1. **Global Load Balancer**
   - Single global IP address for worldwide access
   - Automatic traffic distribution based on proximity and health
   - SSL termination and HTTP/HTTPS support

2. **Cloud CDN**
   - Caches static content at edge locations
   - Reduces latency and bandwidth costs
   - Automatic cache invalidation

3. **Backend Service**
   - Health checks every 30 seconds
   - Session affinity configuration
   - Connection draining for zero-downtime updates

4. **Managed Instance Group**
   - Auto-scaling based on CPU utilization
   - Auto-healing with health check integration
   - Rolling updates for zero-downtime deployments

5. **Compute Engine Instances**
   - Containerized Flask application
   - Docker-based deployment
   - Startup scripts for automatic configuration

## Prerequisites

- Google Cloud Platform account with billing enabled
- Google Cloud SDK installed and configured
- Terraform installed (version >= 1.0)
- Docker installed (for local testing)

## Deployment Steps

### 1. Clone and Setup

```bash
git clone <repository-url>
cd Global_Load_Balancing_Solution2
```

### 2. Configure GCP Project

```bash
# Set your GCP project ID
export PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Enable required APIs
gcloud services enable compute.googleapis.com
gcloud services enable containerregistry.googleapis.com
```

### 3. Build and Push Docker Image

```bash
# Build the Docker image
docker build -t gcr.io/$PROJECT_ID/global-lb-app:latest ./docker

# Push to Google Container Registry
docker push gcr.io/$PROJECT_ID/global-lb-app:latest
```

### 4. Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan -var="project_id=$PROJECT_ID"

# Apply the configuration
terraform apply -var="project_id=$PROJECT_ID"
```

### 5. Access Your Application

After deployment, Terraform will output the global IP address:

```bash
terraform output global_ip
```

Access your application at: `http://<global-ip-address>`

## Configuration

### Terraform Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `project_id` | GCP Project ID | - | Yes |
| `region` | Primary region for deployment | `us-central1` | No |
| `machine_type` | Compute Engine machine type | `e2-micro` | No |
| `instance_count` | Number of instances in MIG | `2` | No |

### Customization

You can customize the deployment by modifying the variables:

```bash
terraform apply \
  -var="project_id=your-project-id" \
  -var="region=us-east1" \
  -var="machine_type=e2-small" \
  -var="instance_count=3"
```

## Monitoring and Maintenance

### Health Checks

The load balancer performs HTTP health checks on port 80 every 30 seconds. Instances are considered unhealthy if they fail 3 consecutive checks.

### Scaling

The Managed Instance Group automatically scales based on:
- CPU utilization (target: 70%)
- Minimum instances: 2
- Maximum instances: 10

### Logging

Access logs are available in Cloud Logging:
- Load balancer access logs
- Instance application logs
- Health check logs

## Security Considerations

- Instances run in the default VPC network
- HTTP traffic only (HTTPS can be enabled with SSL certificates)
- No public SSH access to instances
- Container images from trusted sources only

## Cost Optimization

- Uses `e2-micro` instances for cost efficiency
- Cloud CDN reduces bandwidth costs
- Auto-scaling prevents over-provisioning
- Consider using preemptible instances for non-critical workloads

## Troubleshooting

### Common Issues

1. **Health Check Failures**
   - Verify Docker container is running on port 80
   - Check firewall rules allow HTTP traffic
   - Review startup script logs

2. **Deployment Failures**
   - Ensure all required APIs are enabled
   - Verify project has sufficient quota
   - Check Terraform state for conflicts

3. **Performance Issues**
   - Monitor CPU utilization
   - Check CDN cache hit rates
   - Review load balancer metrics

### Useful Commands

```bash
# Check instance health
gcloud compute health-checks list

# View load balancer logs
gcloud logging read "resource.type=gce_forwarding_rule"

# Monitor instance group
gcloud compute instance-groups managed describe app-mig
```

## Cleanup

To destroy all resources:

```bash
terraform destroy -var="project_id=$PROJECT_ID"
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Create an issue in the repository
- Contact: [Your Contact Information]

---

**Note:** This solution is designed for demonstration and learning purposes. For production use, consider additional security measures, monitoring, and backup strategies.
