**Project Architecture Overview**

This project is structured into four main folders, each serving a distinct purpose in the development, deployment, and automation process. Below is a detailed explanation of the architecture, including the roles of each folder and how they interact with one another.

*Folder Structure*
- .github/
  - workflows/
    - github-action.yml
- app/
  - Dockerfile
  - main.go
  - go.mod
- helm-chart/charts
  - Chart.yaml
  - values.yaml
  - templates
- terraform/
  - modules/
  - variables.tf
  - outputs.tf
  - main.tf
  - providers.tf
 

    
**1. app/ - Application Source Code and Docker Image**

**Purpose: <br>**
This folder contains the source code of the application, which in this case is a simple Go-based "Hello World" application, along with a Dockerfile used to containerize the application.

        Key Points:

        The Dockerfile is used to package the main.go application into a Docker image.
        The resulting image is pushed in ghcr.io container registry (**ghcr.io/alinhantoiu/app**), which will be referenced by the Helm chart for deployment.

**2. helm-chart/ - Helm Chart for Kubernetes Deployment**

**Purpose: <br>**
This folder contains the Helm chart, which defines the Kubernetes resources needed to deploy the application. The Helm chart is configured to use the Docker image built from the app/ folder.

        Key Points:

        *Dynamic Secret Creation in Kubernetes*:<br>

        The **values.yaml** file in the Helm chart includes a **secret.data** section, intended for sensitive information such as usernames and passwords.<br>
        These values are securely passed from GitHub Secrets during deployment using the **--set** flag.<br>
        When you deploy the Helm chart, it uses these provided values to create a Kubernetes Secret. This Secret is automatically generated within your Kubernetes cluster, ensuring that sensitive information is securely stored.

**3. terraform/ - Infrastructure Provisioning with Terraform**

**Purpose: <br>**
This folder contains the Terraform configuration files used to provision infrastructure on AWS. This includes setting up a Virtual Private Cloud (VPC), Security Group, and an EC2 instance where K3s (a lightweight Kubernetes distribution) is installed and the helm chart is deployed.

        Key Points:
        
        Terraform provisions the necessary infrastructure in AWS, including networking components and compute resources.
        After provisioning, Terraform also handles the installation of K3s on the EC2 instance.
        Once K3s is installed, Terraform deploys the Helm chart to the K3s cluster, effectively deploying the application.
        The kubernetes config file is downloaded on local in order to access kubernetes from your local.
