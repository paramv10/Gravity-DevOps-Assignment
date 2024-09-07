# Gravity-DevOps-Assignment
DevOps Engineer Assignment

Tasks:

# Automated Infrastructure Setup
## Use Terraform to provision a GCP environment with the following components:
1. One VPC with two subnets (public and private).
2. A Compute Engine instance in the public subnet with a web server installed (e.g., Nginx
or Apache).
3. Firewall rules that allow HTTP/HTTPS traffic to the instance.

# CI/CD Pipeline
1. Set up a basic CI/CD pipeline using Google Cloud Build or Jenkins to deploy a simple web
application.
2. Configure the pipeline to:
3. Pull code from a Git repository.
4.  Build and test the application.
5.   Deploy the application to the Compute Engine instance.
6.    Include automated tests and ensure they pass before deployment.

# Monitoring and Logging
1. Integrate Google Cloud Monitoring to monitor the instance&#39;s CPU, memory, and disk usage.
2.  Set up a basic alert to notify you via email if CPU usage exceeds 80%.
