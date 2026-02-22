Azure Serverless QR Code Generator Deployment

## Overview
This Terraform project automates the deployment of a **serverless Azure Function App** that integrates with the **Azure QR Code Generator**.  
It provisions the necessary Azure resources, including Resource Groups, Storage Accounts, Service Plans, and Linux-based Function Apps, 
enabling dynamic QR code generation and storage in Azure Blob Storage.

The project leverages the [Azure QR Code Generator](https://github.com/rishabkumar7/azure-qr-code) by **Rishab Kumar** for the actual QR code generation functionality.

---

## Prerequisites
Before deploying this project, ensure you have the following:

- [Terraform](https://www.terraform.io/downloads.html) (>= 1.9.0)  
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)  
- An **Azure account** with necessary permissions  
- Node.js (for the QR Code generator integration)  
- Azure Functions Core Tools (for local testing if needed)  
- Access to an **Azure Storage Account**  

---
## Project Structure
    terraform_files/
        ├── provider.tf # Azure provider configuration
        ├── terraform.tf # Backend & provider requirements
        ├── variables.tf # Input variable definitions
        ├── terraform.tfvars # Environment-specific variable values
        └── README.md # Project documentation



---

## Deployment & Usage

### 1. Configure Terraform Variables

    Update `terraform.tfvars` with your Azure Service Principal credentials, resource group, storage account, service plan, and function app details.
    
    Example:
    ```hcl
    service_principal = {
      client_id       = "<CLIENT_ID>"
      client_secret   = "<CLIENT_SECRET>"
      tenant_id       = "<TENANT_ID>"
      subscription_id = "<SUBSCRIPTION_ID>"
    }
    
    rg_details = {
      name     = "<RESOURCE_GROUP_NAME>"
      location = "<LOCATION>"
    }

2. Initialize Terraform
3. 
        terraform init

3. Plan & Apply

    terraform plan
    terraform apply

Terraform will provision:

    Resource Group
    Storage Account (with unique name)
    Service Plan (Linux-based)
    Function App (with Node.js runtime)


Integration with Azure QR Code Generator
    
    This project uses the open-source QR code generator by Rishab Kumar:
    GitHub: https://github.com/rishabkumar7/azure-qr-code
    
    Features:
    
    Serverless: Uses Azure Functions for minimal infrastructure management
    QR Code Generation: Dynamically generates QR codes for any given URL
    Azure Blob Storage: Stores QR codes in cloud storage for easy access

Deploy QR Code Generator

    After the Terraform deployment:
    Clone the QR code repo:
    
    git clone https://github.com/rishabkumar7/azure-qr-code.git
    cd azure-qr-code/qrCodeGenerator
    
    Install dependencies:
    npm install
    Configure local.settings.json:

    {
        "IsEncrypted": false,
        "Values": {
            "AzureWebJobsStorage": "<STORAGE_CONNECTION_STRING>",
            "FUNCTIONS_WORKER_RUNTIME": "node"
                "STORAGE_CONNECTION_STRING":"<YOUR_STORAGE_CONNECTION_STRING>"
        }
    }

    Navigate to your Storage Account created during Terraform deployment
    From the left menu, go to:
    Security + networking → Access keys
    Locate the Connection string value
    Copy the connection string and paste it into your local.settings.json file:


Deploy to Azure:

    func azure functionapp publish <YOUR_FUNCTION_APP_NAME> --publish-local-settings

Test by sending a GET request:

    curl -X GET https://<YOUR_FUNCTION_URL>/api/GenerateQRCode \
      -H "Content-Type: application/json" \
      -d '{"url":"https://www.example.com"}'

### Expected Result

    After sending the request, the Azure Function will:
    
       1. Generate a QR code for the provided URL  
       2. Upload the generated QR image to Azure Blob Storage  
       3. Return a response containing the QR code file URL or confirmation message  

Example response:

    ```json
    {
      "message": "QR Code generated successfully",
      "blobUrl": "https://<storage-account>.blob.core.windows.net/<container>/qrcode.png"
    }
    
    You can open the returned blobUrl in your browser to view or download the generated QR code image.