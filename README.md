# Cloud Run with Terraform

This project sets up a Cloud Run service on Google Cloud Platform using Terraform.

## Prerequisites

- Google Cloud SDK
- Terraform

## Setup

1. **Clone this repository:**

    ```sh
    git clone <repository-url>
    cd <repository-directory>
    ```

2. **Create a new GCP project:**

    ```sh
    gcloud projects create my-cloud-run-project
    gcloud config set project my-cloud-run-project
    ```

3. **Enable the required APIs:**

    ```sh
    gcloud services enable run.googleapis.com
    gcloud services enable cloudbuild.googleapis.com
    gcloud services enable artifactregistry.googleapis.com
    ```

4. **Build and push the Docker image:**

    ```sh
    gcloud artifacts repositories create my-repo --repository-format=docker --location=us-central1
    docker build -t us-central1-docker.pkg.dev/my-cloud-run-project/my-repo/hello-world:latest .
    gcloud auth configure-docker us-central1-docker.pkg.dev
    docker push us-central1-docker.pkg.dev/my-cloud-run-project/my-repo/hello-world:latest
    ```

5. **Deploy using Terraform:**

    ```sh
    terraform init
    terraform apply -var="project_id=my-cloud-run-project"
    ```

6. **Access the Cloud Run service:**

    After the deployment is complete, you can access the Cloud Run service using the URL provided in the Terraform output.

## Cleanup

To delete the resources created by Terraform, run:

```sh
terraform destroy -var="project_id=my-cloud-run-project"
