# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
1. Get Azure Account information:
  - AZ_SUSCRIPTION_ID=00000000-0000-0000-0000-000000000000
  - AZ_TENANT_ID=00000000-0000-0000-0000-000000000000
  - AZ_CLIENT_ID=00000000-0000-0000-0000-000000000000
  - AZ_CLIENT_SECRET=000000000000000000000

2. Export Azure Account information variables
  - Run the following command
  ``` bash
  export AZ_SUSCRIPTION_ID=00000000-0000-0000-0000-000000000000
  export AZ_TENANT_ID=00000000-0000-0000-0000-000000000000
  export AZ_CLIENT_ID=00000000-0000-0000-0000-000000000000
  export AZ_CLIENT_SECRET=000000000000000000000
  ```
2. Deploy a policy
  - Navigate to the policies directory.
  - Update policyName in create_tagging_policy.sh
  - Make script executable:
  ``` bash
  chmod +x create_tagging_policy.sh 
  ```
  
  - Run the script to create the tagging policy
  ``` bash
  ./create_tagging_policy.sh 
  ```

  - Check that the policy exists
  ``` bash
  az policy assignment list
  ```
3. Create a resource group for packer image
  - Check resource group list
  ``` bash
  az az group list
  ```
  - Run the script to create a resource group
  ``` bash
  az group create -n <resource-group-name> -l <location> 
  ```

4. Packer Template - Create a Server Image
  - Navigate to the packer directory.
  - Update image_name, resource_group, location and vm_size in create_tagging_policy.sh
  - Run the script to create a server image
  ``` bash
  packer build server.json
  ```

5. Terraform Template - Create the infrastructure
  - Navigate to the terraform directory
  - Initialize the workspace
  ``` bash
  terraform init
  ```
  
  - Check terraform syntax
  ``` bash
  terraform validate
  ```

  - Import existing resource group to terraform state
  ``` bash
  terraform import azurerm_resource_group.main /subscriptions/<subscription-id>/resourceGroups/<resource-group-name>
  ```

  - Plan before deploy
  ``` bash
  terraform plan -out solution.plan
  ```
  
  - Deploy the resources
  ``` bash
  terraform apply "solution.plan"
  ```

6. Destroy resources
  - Confirm destruction by typing "yes"
  ``` bash
  terraform destroy
  ```

### Output
1. Output after running the create_tagging_policy.sh
2. Output after create a resource group
3. Output after create a server image using packer
4. Output after importing existing resource group to terraform state
5. Output after executing the terraform plan command
6. Output after executing the terraform apply command
7. Output after executing the terraform destroy command