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
  - AZ_SUBSCRIPTION_ID=00000000-0000-0000-0000-000000000000
  - AZ_TENANT_ID=00000000-0000-0000-0000-000000000000
  - AZ_CLIENT_ID=00000000-0000-0000-0000-000000000000
  - AZ_CLIENT_SECRET=000000000000000000000

2. Export Azure Account information variables
  - Run the following command
  ``` bash
  export AZ_SUBSCRIPTION_ID=00000000-0000-0000-0000-000000000000
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

#### Note about vars.tf

To customize the vars.tf file for use, you can modify the default values and descriptions of the variables according to your specific requirements. Here's a brief description of the variables and how you can customize them:

1. resource_group_name: This variable represents the name of the resource group where the resources will be created. You can modify the default value to specify your desired resource group name.

2. location: This variable defines the Azure region where the resources will be deployed. You can update the default value to set the desired region.

3. tags: This variable is a map of tags that can be assigned to the deployed resources. You can customize the default value to add or modify tags according to your tagging strategy.

4. packer_resource_group_name: This variable represents the name of the resource group where the Packer image will be created. You can change the default value to set your preferred resource group name.

5. packer_image_name: This variable defines the name of the Packer image. You can update the default value to specify the desired image name.

6. prefix: This variable sets the prefix to be used for all resources within the specified resource group. You can modify the default value to set your preferred prefix.

7. environment: This variable specifies the environment to be built. You can update the default value to reflect the desired environment (e.g., development, production, staging).

8. azure-subscription-id, azure-client-id, azure-client-secret, azure-tenant-id: These variables are used for Azure authentication. You need to provide the appropriate values for these variables to authenticate with your Azure subscription. Make sure to replace the default values with your own Azure credentials.

9. network-interfaces-count: This variable determines the number of network interfaces to be created. You can modify the default value to specify the desired count.

10. admin-user: This variable sets the username for the virtual machine's admin user. You can update the default value to specify your desired admin username.

11. admin-password: This variable represents the password for the virtual machine's admin user. You should update the default value with your desired admin password. Alternatively, you can modify the variable to prompt for the password during deployment.

12. vm-size: This variable defines the size of the virtual machine. You can change the default value to set the desired VM size.

13. num_of_vms: This variable determines the number of virtual machine resources to create behind the load balancer. You can modify the default value to specify the desired number of VMs.

After customizing the variables in the vars.tf file, you can use them in your Terraform code to create and configure Azure resources based on your specific requirements.

### Output
1. Output after running the create_tagging_policy.sh
``` bash
congdinh@CONGs-MacBook-Pro policies % ./create_tagging_policy.sh 
{
  "description": "Enforces a required tag and its value. Does not apply to resource groups.",
  "displayName": "Require a tag on resources",
  "id": "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/providers/Microsoft.Authorization/policyDefinitions/tagging-policy",
  "metadata": {
    "createdBy": "9e2850b3-9974-404e-aa58-855f8454de28",
    "createdOn": "2023-05-19T04:17:16.6911972Z",
    "updatedBy": null,
    "updatedOn": null
  },
  "mode": "Indexed",
  "name": "tagging-policy",
  "parameters": {
    "tagName": {
      "allowedValues": null,
      "defaultValue": null,
      "metadata": {
        "additionalProperties": null,
        "assignPermissions": null,
        "description": "Name of the tag, such as 'environment'",
        "displayName": "Tag Name",
        "strongType": null
      },
      "type": "String"
    },
    "tagValue": {
      "allowedValues": null,
      "defaultValue": null,
      "metadata": {
        "additionalProperties": null,
        "assignPermissions": null,
        "description": "Value of the tag, such as 'production'",
        "displayName": "Tag Value",
        "strongType": null
      },
      "type": "String"
    }
  },
  "policyRule": {
    "if": {
      "not": {
        "equals": "[parameters('tagValue')]",
        "field": "[concat('tags[', parameters('tagName'), ']')]"
      }
    },
    "then": {
      "effect": "deny"
    }
  },
  "policyType": "Custom",
  "systemData": {
    "createdAt": "2023-05-19T04:17:16.650532+00:00",
    "createdBy": "odl_user_233984@udacityhol.onmicrosoft.com",
    "createdByType": "User",
    "lastModifiedAt": "2023-05-19T04:17:16.650532+00:00",
    "lastModifiedBy": "odl_user_233984@udacityhol.onmicrosoft.com",
    "lastModifiedByType": "User"
  },
  "type": "Microsoft.Authorization/policyDefinitions"
}
Readonly attribute scope will be ignored in class <class 'azure.mgmt.resource.policy.v2021_06_01.models._models_py3.PolicyAssignment'>
{
  "description": "Enforces a required tag and its value. Does not apply to resource groups.",
  "displayName": "Require a tag on resources",
  "enforcementMode": "Default",
  "id": "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/providers/Microsoft.Authorization/policyAssignments/tagging-policy",
  "identity": null,
  "location": null,
  "metadata": {
    "createdBy": "9e2850b3-9974-404e-aa58-855f8454de28",
    "createdOn": "2023-05-19T04:17:17.7788334Z",
    "updatedBy": null,
    "updatedOn": null
  },
  "name": "tagging-policy",
  "nonComplianceMessages": null,
  "notScopes": null,
  "parameters": {
    "tagName": {
      "value": "create-by"
    },
    "tagValue": {
      "value": "congdinh2023"
    }
  },
  "policyDefinitionId": "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/providers/Microsoft.Authorization/policyDefinitions/tagging-policy",
  "scope": "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d",
  "systemData": {
    "createdAt": "2023-05-19T04:17:17.754324+00:00",
    "createdBy": "odl_user_233984@udacityhol.onmicrosoft.com",
    "createdByType": "User",
    "lastModifiedAt": "2023-05-19T04:17:17.754324+00:00",
    "lastModifiedBy": "odl_user_233984@udacityhol.onmicrosoft.com",
    "lastModifiedByType": "User"
  },
  "type": "Microsoft.Authorization/policyAssignments"
}
```

2. Output after create a server image using packer
``` bash
congdinh@CONGs-MacBook-Pro packer % packer build server.json
azure-arm: output will be in this color.

==> azure-arm: Running builder ...
==> azure-arm: Getting tokens using client secret
==> azure-arm: Getting tokens using client secret
    azure-arm: Creating Azure Resource Manager (ARM) client ...
==> azure-arm: Getting source image id for the deployment ...
==> azure-arm:  -> SourceImageName: '/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/providers/Microsoft.Compute/locations/westeurope/publishers/Canonical/ArtifactTypes/vmimage/offers/UbuntuServer/skus/18.04-LTS/versions/latest'
==> azure-arm: Creating resource group ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-yetkx7skbj'
==> azure-arm:  -> Location          : 'westeurope'
==> azure-arm:  -> Tags              :
==> azure-arm:  ->> create-by : congdinh2023
==> azure-arm: Validating deployment template ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-yetkx7skbj'
==> azure-arm:  -> DeploymentName    : 'pkrdpyetkx7skbj'
==> azure-arm: Deploying deployment template ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-yetkx7skbj'
==> azure-arm:  -> DeploymentName    : 'pkrdpyetkx7skbj'
==> azure-arm: Getting the VM's IP address ...
==> azure-arm:  -> ResourceGroupName   : 'pkr-Resource-Group-yetkx7skbj'
==> azure-arm:  -> PublicIPAddressName : 'pkripyetkx7skbj'
==> azure-arm:  -> NicName             : 'pkrniyetkx7skbj'
==> azure-arm:  -> Network Connection  : 'PublicEndpoint'
==> azure-arm:  -> IP Address          : '40.113.156.114'
==> azure-arm: Waiting for SSH to become available...
==> azure-arm: Connected to SSH!
==> azure-arm: Provisioning with shell script: /var/folders/2q/hjx9rqs53hx_dfc7mrj142340000gn/T/packer-shell838229956
==> azure-arm: + echo Hello, World!
==> azure-arm: Querying the machine's properties ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-yetkx7skbj'
==> azure-arm:  -> ComputeName       : 'pkrvmyetkx7skbj'
==> azure-arm:  -> Managed OS Disk   : '/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/pkr-Resource-Group-yetkx7skbj/providers/Microsoft.Compute/disks/pkrosyetkx7skbj'
==> azure-arm: Querying the machine's additional disks properties ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-yetkx7skbj'
==> azure-arm:  -> ComputeName       : 'pkrvmyetkx7skbj'
==> azure-arm: Powering off machine ...
==> azure-arm:  -> ResourceGroupName : 'pkr-Resource-Group-yetkx7skbj'
==> azure-arm:  -> ComputeName       : 'pkrvmyetkx7skbj'
==> azure-arm: Generalizing machine ...
==> azure-arm:  -> Compute ResourceGroupName : 'pkr-Resource-Group-yetkx7skbj'
==> azure-arm:  -> Compute Name              : 'pkrvmyetkx7skbj'
==> azure-arm:  -> Compute Location          : 'westeurope'
==> azure-arm: Capturing image ...
==> azure-arm:  -> Image ResourceGroupName   : 'Azuredevops'
==> azure-arm:  -> Image Name                : 'udacity-ubuntu-server-image'
==> azure-arm:  -> Image Location            : 'westeurope'
==> azure-arm: 
==> azure-arm: Deleting individual resources ...
==> azure-arm: Adding to deletion queue -> Microsoft.Compute/virtualMachines : 'pkrvmyetkx7skbj'
==> azure-arm: Adding to deletion queue -> Microsoft.Network/networkInterfaces : 'pkrniyetkx7skbj'
==> azure-arm: Adding to deletion queue -> Microsoft.Network/publicIPAddresses : 'pkripyetkx7skbj'
==> azure-arm: Adding to deletion queue -> Microsoft.Network/virtualNetworks : 'pkrvnyetkx7skbj'
==> azure-arm: Waiting for deletion of all resources...
==> azure-arm: Attempting deletion -> Microsoft.Network/virtualNetworks : 'pkrvnyetkx7skbj'
==> azure-arm: Attempting deletion -> Microsoft.Network/publicIPAddresses : 'pkripyetkx7skbj'
==> azure-arm: Attempting deletion -> Microsoft.Network/networkInterfaces : 'pkrniyetkx7skbj'
==> azure-arm: Attempting deletion -> Microsoft.Compute/virtualMachines : 'pkrvmyetkx7skbj'
==> azure-arm: Error deleting resource. Will retry.
==> azure-arm: Name: pkripyetkx7skbj
==> azure-arm: Error: network.PublicIPAddressesClient#Delete: Failure sending request: StatusCode=400 -- Original Error: Code="PublicIPAddressCannotBeDeleted" Message="Public IP address /subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/pkr-Resource-Group-yetkx7skbj/providers/Microsoft.Network/publicIPAddresses/pkripyetkx7skbj can not be deleted since it is still allocated to resource /subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/pkr-Resource-Group-yetkx7skbj/providers/Microsoft.Network/networkInterfaces/pkrniyetkx7skbj/ipConfigurations/ipconfig. In order to delete the public IP, disassociate/detach the Public IP address from the resource.  To learn how to do this, see aka.ms/deletepublicip." Details=[]
==> azure-arm:
==> azure-arm: Error deleting resource. Will retry.
==> azure-arm: Name: pkrniyetkx7skbj
==> azure-arm: Error: network.InterfacesClient#Delete: Failure sending request: StatusCode=400 -- Original Error: Code="NicInUse" Message="Network Interface /subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/pkr-Resource-Group-yetkx7skbj/providers/Microsoft.Network/networkInterfaces/pkrniyetkx7skbj is used by existing resource /subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/pkr-Resource-Group-yetkx7skbj/providers/Microsoft.Compute/virtualMachines/pkrvmyetkx7skbj. In order to delete the network interface, it must be dissociated from the resource. To learn more, see aka.ms/deletenic." Details=[]
==> azure-arm:
==> azure-arm: Error deleting resource. Will retry.
==> azure-arm: Name: pkrvnyetkx7skbj
==> azure-arm: Error: network.VirtualNetworksClient#Delete: Failure sending request: StatusCode=400 -- Original Error: Code="InUseSubnetCannotBeDeleted" Message="Subnet pkrsnyetkx7skbj is in use by /subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/pkr-Resource-Group-yetkx7skbj/providers/Microsoft.Network/networkInterfaces/pkrniyetkx7skbj/ipConfigurations/ipconfig and cannot be deleted. In order to delete the subnet, delete all the resources within the subnet. See aka.ms/deletesubnet." Details=[]
==> azure-arm:
==> azure-arm: Attempting deletion -> Microsoft.Network/networkInterfaces : 'pkrniyetkx7skbj'
==> azure-arm: Attempting deletion -> Microsoft.Network/publicIPAddresses : 'pkripyetkx7skbj'
==> azure-arm: Attempting deletion -> Microsoft.Network/virtualNetworks : 'pkrvnyetkx7skbj'
==> azure-arm:  Deleting -> Microsoft.Compute/disks : '/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/pkr-Resource-Group-yetkx7skbj/providers/Microsoft.Compute/disks/pkrosyetkx7skbj'
==> azure-arm: Removing the created Deployment object: 'pkrdpyetkx7skbj'
==> azure-arm: 
==> azure-arm: Cleanup requested, deleting resource group ...
==> azure-arm: Resource group has been deleted.
Build 'azure-arm' finished after 5 minutes 28 seconds.

==> Wait completed after 5 minutes 28 seconds

==> Builds finished. The artifacts of successful builds are:
--> azure-arm: Azure.ResourceManagement.VMImage:

OSType: Linux
ManagedImageResourceGroupName: Azuredevops
ManagedImageName: udacity-ubuntu-server-image
ManagedImageId: /subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/images/udacity-ubuntu-server-image
ManagedImageLocation: westeurope
```
3. Output after importing existing resource group to terraform state
``` bash
congdinh@CONGs-MacBook-Pro terraform % terraform import azurerm_resource_group.main /subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops

azurerm_resource_group.main: Importing from ID "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops"...
data.azurerm_image.packer-image: Reading...
azurerm_resource_group.main: Import prepared!
  Prepared azurerm_resource_group for import
azurerm_resource_group.main: Refreshing state... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops]
data.azurerm_image.packer-image: Read complete after 2s [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/images/udacity-ubuntu-server-image]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.

```
4. Output after executing the terraform plan command
``` bash
congdinh@CONGs-MacBook-Pro terraform % terraform plan -out solution.plan

data.azurerm_image.packer-image: Reading...
azurerm_resource_group.main: Refreshing state... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops]
data.azurerm_image.packer-image: Read complete after 2s [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/images/udacity-ubuntu-server-image]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_availability_set.main will be created
  + resource "azurerm_availability_set" "main" {
      + id                           = (known after apply)
      + location                     = "westeurope"
      + managed                      = true
      + name                         = "udacity-project1-vmset"
      + platform_fault_domain_count  = 2
      + platform_update_domain_count = 5
      + resource_group_name          = "Azuredevops"
      + tags                         = {
          + "create-by" = "congdinh2023"
        }
    }

  # azurerm_lb.main will be created
  + resource "azurerm_lb" "main" {
      + id                   = (known after apply)
      + location             = "westeurope"
      + name                 = "udacity-project1-lb"
      + private_ip_address   = (known after apply)
      + private_ip_addresses = (known after apply)
      + resource_group_name  = "Azuredevops"
      + sku                  = "Basic"
      + sku_tier             = "Regional"
      + tags                 = {
          + "create-by" = "congdinh2023"
        }

      + frontend_ip_configuration {
          + availability_zone                                  = (known after apply)
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + id                                                 = (known after apply)
          + inbound_nat_rules                                  = (known after apply)
          + load_balancer_rules                                = (known after apply)
          + name                                               = "publicIPAddress"
          + outbound_rules                                     = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = (known after apply)
          + private_ip_address_version                         = (known after apply)
          + public_ip_address_id                               = (known after apply)
          + public_ip_prefix_id                                = (known after apply)
          + subnet_id                                          = (known after apply)
          + zones                                              = (known after apply)
        }
    }

  # azurerm_lb_backend_address_pool.main will be created
  + resource "azurerm_lb_backend_address_pool" "main" {
      + backend_ip_configurations = (known after apply)
      + id                        = (known after apply)
      + load_balancing_rules      = (known after apply)
      + loadbalancer_id           = (known after apply)
      + name                      = "udacity-project1-BackEndAddressPool"
      + outbound_rules            = (known after apply)
      + resource_group_name       = (known after apply)
    }

  # azurerm_linux_virtual_machine.main[0] will be created
  + resource "azurerm_linux_virtual_machine" "main" {
      + admin_password                  = (sensitive value)
      + admin_username                  = "congdinh2023"
      + allow_extension_operations      = true
      + availability_set_id             = (known after apply)
      + computer_name                   = (known after apply)
      + disable_password_authentication = false
      + extensions_time_budget          = "PT1H30M"
      + id                              = (known after apply)
      + location                        = "westeurope"
      + max_bid_price                   = -1
      + name                            = "udacity-project1-vm-0"
      + network_interface_ids           = (known after apply)
      + patch_mode                      = "ImageDefault"
      + platform_fault_domain           = -1
      + priority                        = "Regular"
      + private_ip_address              = (known after apply)
      + private_ip_addresses            = (known after apply)
      + provision_vm_agent              = true
      + public_ip_address               = (known after apply)
      + public_ip_addresses             = (known after apply)
      + resource_group_name             = "Azuredevops"
      + size                            = "Standard_B1s"
      + source_image_id                 = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/images/udacity-ubuntu-server-image"
      + tags                            = {
          + "create-by" = "congdinh2023"
        }
      + virtual_machine_id              = (known after apply)
      + zone                            = (known after apply)

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + name                      = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }
    }

  # azurerm_linux_virtual_machine.main[1] will be created
  + resource "azurerm_linux_virtual_machine" "main" {
      + admin_password                  = (sensitive value)
      + admin_username                  = "congdinh2023"
      + allow_extension_operations      = true
      + availability_set_id             = (known after apply)
      + computer_name                   = (known after apply)
      + disable_password_authentication = false
      + extensions_time_budget          = "PT1H30M"
      + id                              = (known after apply)
      + location                        = "westeurope"
      + max_bid_price                   = -1
      + name                            = "udacity-project1-vm-1"
      + network_interface_ids           = (known after apply)
      + patch_mode                      = "ImageDefault"
      + platform_fault_domain           = -1
      + priority                        = "Regular"
      + private_ip_address              = (known after apply)
      + private_ip_addresses            = (known after apply)
      + provision_vm_agent              = true
      + public_ip_address               = (known after apply)
      + public_ip_addresses             = (known after apply)
      + resource_group_name             = "Azuredevops"
      + size                            = "Standard_B1s"
      + source_image_id                 = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/images/udacity-ubuntu-server-image"
      + tags                            = {
          + "create-by" = "congdinh2023"
        }
      + virtual_machine_id              = (known after apply)
      + zone                            = (known after apply)

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + name                      = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }
    }

  # azurerm_managed_disk.main will be created
  + resource "azurerm_managed_disk" "main" {
      + create_option                 = "Empty"
      + disk_iops_read_only           = (known after apply)
      + disk_iops_read_write          = (known after apply)
      + disk_mbps_read_only           = (known after apply)
      + disk_mbps_read_write          = (known after apply)
      + disk_size_gb                  = 1
      + id                            = (known after apply)
      + location                      = "westeurope"
      + logical_sector_size           = (known after apply)
      + max_shares                    = (known after apply)
      + name                          = "udacity-project1-md"
      + public_network_access_enabled = true
      + resource_group_name           = "Azuredevops"
      + source_uri                    = (known after apply)
      + storage_account_type          = "Standard_LRS"
      + tags                          = {
          + "create-by" = "congdinh2023"
        }
      + tier                          = (known after apply)
    }

  # azurerm_network_interface.main[0] will be created
  + resource "azurerm_network_interface" "main" {
      + applied_dns_servers           = (known after apply)
      + dns_servers                   = (known after apply)
      + enable_accelerated_networking = false
      + enable_ip_forwarding          = false
      + id                            = (known after apply)
      + internal_dns_name_label       = (known after apply)
      + internal_domain_name_suffix   = (known after apply)
      + location                      = "westeurope"
      + mac_address                   = (known after apply)
      + name                          = "udacity-project1-NIC-0"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "Azuredevops"
      + tags                          = {
          + "create-by" = "congdinh2023"
        }
      + virtual_machine_id            = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "internal"
          + primary                                            = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "dynamic"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = (known after apply)
        }
    }

  # azurerm_network_interface.main[1] will be created
  + resource "azurerm_network_interface" "main" {
      + applied_dns_servers           = (known after apply)
      + dns_servers                   = (known after apply)
      + enable_accelerated_networking = false
      + enable_ip_forwarding          = false
      + id                            = (known after apply)
      + internal_dns_name_label       = (known after apply)
      + internal_domain_name_suffix   = (known after apply)
      + location                      = "westeurope"
      + mac_address                   = (known after apply)
      + name                          = "udacity-project1-NIC-1"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "Azuredevops"
      + tags                          = {
          + "create-by" = "congdinh2023"
        }
      + virtual_machine_id            = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "internal"
          + primary                                            = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "dynamic"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = (known after apply)
        }
    }

  # azurerm_network_interface_backend_address_pool_association.main[0] will be created
  + resource "azurerm_network_interface_backend_address_pool_association" "main" {
      + backend_address_pool_id = (known after apply)
      + id                      = (known after apply)
      + ip_configuration_name   = "internal"
      + network_interface_id    = (known after apply)
    }

  # azurerm_network_interface_backend_address_pool_association.main[1] will be created
  + resource "azurerm_network_interface_backend_address_pool_association" "main" {
      + backend_address_pool_id = (known after apply)
      + id                      = (known after apply)
      + ip_configuration_name   = "internal"
      + network_interface_id    = (known after apply)
    }

  # azurerm_network_security_group.main will be created
  + resource "azurerm_network_security_group" "main" {
      + id                  = (known after apply)
      + location            = "westeurope"
      + name                = "udacity-project1-sg"
      + resource_group_name = "Azuredevops"
      + security_rule       = [
          + {
              + access                                     = "Allow"
              + description                                = ""
              + destination_address_prefix                 = "*"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "80"
              + destination_port_ranges                    = []
              + direction                                  = "Inbound"
              + name                                       = "AllowHTTPIncome"
              + priority                                   = 102
              + protocol                                   = "Tcp"
              + source_address_prefix                      = "*"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
            },
          + {
              + access                                     = "Allow"
              + description                                = ""
              + destination_address_prefix                 = "10.0.2.0/24"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "*"
              + destination_port_ranges                    = []
              + direction                                  = "Inbound"
              + name                                       = "AllowInboundInternal"
              + priority                                   = 100
              + protocol                                   = "*"
              + source_address_prefix                      = "10.0.2.0/24"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
            },
          + {
              + access                                     = "Allow"
              + description                                = ""
              + destination_address_prefix                 = "10.0.2.0/24"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "*"
              + destination_port_ranges                    = []
              + direction                                  = "Outbound"
              + name                                       = "AllowOutboundInternal"
              + priority                                   = 101
              + protocol                                   = "*"
              + source_address_prefix                      = "10.0.2.0/24"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
            },
          + {
              + access                                     = "Deny"
              + description                                = ""
              + destination_address_prefix                 = "*"
              + destination_address_prefixes               = []
              + destination_application_security_group_ids = []
              + destination_port_range                     = "*"
              + destination_port_ranges                    = []
              + direction                                  = "Inbound"
              + name                                       = "DenyDirectAccessFromtheInternet"
              + priority                                   = 1000
              + protocol                                   = "*"
              + source_address_prefix                      = "*"
              + source_address_prefixes                    = []
              + source_application_security_group_ids      = []
              + source_port_range                          = "*"
              + source_port_ranges                         = []
            },
        ]
      + tags                = {
          + "create-by" = "congdinh2023"
        }
    }

  # azurerm_public_ip.main will be created
  + resource "azurerm_public_ip" "main" {
      + allocation_method       = "Static"
      + availability_zone       = (known after apply)
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + idle_timeout_in_minutes = 4
      + ip_address              = (known after apply)
      + ip_version              = "IPv4"
      + location                = "westeurope"
      + name                    = "vmss-public-ip"
      + resource_group_name     = "Azuredevops"
      + sku                     = "Basic"
      + sku_tier                = "Regional"
      + tags                    = {
          + "create-by" = "congdinh2023"
        }
      + zones                   = (known after apply)
    }

  # azurerm_subnet.main will be created
  + resource "azurerm_subnet" "main" {
      + address_prefix                                 = (known after apply)
      + address_prefixes                               = [
          + "10.0.2.0/24",
        ]
      + enforce_private_link_endpoint_network_policies = false
      + enforce_private_link_service_network_policies  = false
      + id                                             = (known after apply)
      + name                                           = "udacity-project1-subnet"
      + resource_group_name                            = "Azuredevops"
      + virtual_network_name                           = "udacity-project1-vnet"
    }

  # azurerm_virtual_network.main will be created
  + resource "azurerm_virtual_network" "main" {
      + address_space         = [
          + "10.0.0.0/16",
        ]
      + dns_servers           = (known after apply)
      + guid                  = (known after apply)
      + id                    = (known after apply)
      + location              = "westeurope"
      + name                  = "udacity-project1-vnet"
      + resource_group_name   = "Azuredevops"
      + subnet                = (known after apply)
      + tags                  = {
          + "create-by" = "congdinh2023"
        }
      + vm_protection_enabled = false
    }

Plan: 14 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: solution.plan

To perform exactly these actions, run the following command to apply:
    terraform apply "solution.plan"
```
5. Output after executing the terraform apply command

``` bash
congdinh@CONGs-MacBook-Pro terraform % terraform apply "solution.plan"
azurerm_network_security_group.main: Creating...
azurerm_virtual_network.main: Creating...
azurerm_availability_set.main: Creating...
azurerm_public_ip.main: Creating...
azurerm_managed_disk.main: Creating...
azurerm_availability_set.main: Creation complete after 8s [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/availabilitySets/udacity-project1-vmset]
azurerm_virtual_network.main: Still creating... [10s elapsed]
azurerm_public_ip.main: Still creating... [10s elapsed]
azurerm_network_security_group.main: Still creating... [10s elapsed]
azurerm_managed_disk.main: Still creating... [10s elapsed]
azurerm_public_ip.main: Creation complete after 11s [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/publicIPAddresses/vmss-public-ip]
azurerm_lb.main: Creating...
azurerm_managed_disk.main: Creation complete after 11s [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/disks/udacity-project1-md]
azurerm_network_security_group.main: Creation complete after 12s [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkSecurityGroups/udacity-project1-sg]
azurerm_virtual_network.main: Creation complete after 14s [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/virtualNetworks/udacity-project1-vnet]
azurerm_subnet.main: Creating...
azurerm_lb.main: Creation complete after 9s [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/udacity-project1-lb]
azurerm_lb_backend_address_pool.main: Creating...
azurerm_subnet.main: Still creating... [10s elapsed]
azurerm_subnet.main: Creation complete after 13s [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/virtualNetworks/udacity-project1-vnet/subnets/udacity-project1-subnet]
azurerm_network_interface.main[1]: Creating...
azurerm_network_interface.main[0]: Creating...
azurerm_lb_backend_address_pool.main: Creation complete after 9s [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/udacity-project1-lb/backendAddressPools/udacity-project1-BackEndAddressPool]
azurerm_network_interface.main[0]: Creation complete after 8s [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-0]
azurerm_network_interface.main[1]: Still creating... [10s elapsed]
azurerm_network_interface.main[1]: Creation complete after 12s [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-1]
azurerm_network_interface_backend_address_pool_association.main[0]: Creating...
azurerm_network_interface_backend_address_pool_association.main[1]: Creating...
azurerm_linux_virtual_machine.main[1]: Creating...
azurerm_linux_virtual_machine.main[0]: Creating...
azurerm_network_interface_backend_address_pool_association.main[0]: Creation complete after 7s [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-0/ipConfigurations/internal|/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/udacity-project1-lb/backendAddressPools/udacity-project1-BackEndAddressPool]
azurerm_network_interface_backend_address_pool_association.main[1]: Creation complete after 7s [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-1/ipConfigurations/internal|/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/udacity-project1-lb/backendAddressPools/udacity-project1-BackEndAddressPool]
azurerm_linux_virtual_machine.main[0]: Still creating... [10s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [10s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [20s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [20s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [30s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [30s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [40s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [40s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [50s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [50s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [1m0s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [1m0s elapsed]
azurerm_linux_virtual_machine.main[1]: Still creating... [1m10s elapsed]
azurerm_linux_virtual_machine.main[0]: Still creating... [1m10s elapsed]
azurerm_linux_virtual_machine.main[0]: Creation complete after 1m12s [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/virtualMachines/udacity-project1-vm-0]
azurerm_linux_virtual_machine.main[1]: Creation complete after 1m12s [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/virtualMachines/udacity-project1-vm-1]

Apply complete! Resources: 14 added, 0 changed, 0 destroyed.
```

6. Output after executing the terraform destroy command

``` bash
congdinh@CONGs-MacBook-Pro terraform % terraform destroy

data.azurerm_image.packer-image: Reading...
azurerm_resource_group.main: Refreshing state... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops]
azurerm_network_security_group.main: Refreshing state... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkSecurityGroups/udacity-project1-sg]
azurerm_virtual_network.main: Refreshing state... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/virtualNetworks/udacity-project1-vnet]
azurerm_availability_set.main: Refreshing state... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/availabilitySets/udacity-project1-vmset]
azurerm_public_ip.main: Refreshing state... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/publicIPAddresses/vmss-public-ip]
azurerm_managed_disk.main: Refreshing state... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/disks/udacity-project1-md]
data.azurerm_image.packer-image: Read complete after 1s [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/images/udacity-ubuntu-server-image]
azurerm_subnet.main: Refreshing state... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/virtualNetworks/udacity-project1-vnet/subnets/udacity-project1-subnet]
azurerm_lb.main: Refreshing state... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/udacity-project1-lb]
azurerm_lb_backend_address_pool.main: Refreshing state... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/udacity-project1-lb/backendAddressPools/udacity-project1-BackEndAddressPool]
azurerm_network_interface.main[1]: Refreshing state... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-1]
azurerm_network_interface.main[0]: Refreshing state... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-0]
azurerm_network_interface_backend_address_pool_association.main[0]: Refreshing state... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-0/ipConfigurations/internal|/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/udacity-project1-lb/backendAddressPools/udacity-project1-BackEndAddressPool]
azurerm_network_interface_backend_address_pool_association.main[1]: Refreshing state... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-1/ipConfigurations/internal|/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/udacity-project1-lb/backendAddressPools/udacity-project1-BackEndAddressPool]
azurerm_linux_virtual_machine.main[1]: Refreshing state... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/virtualMachines/udacity-project1-vm-1]
azurerm_linux_virtual_machine.main[0]: Refreshing state... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/virtualMachines/udacity-project1-vm-0]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # azurerm_availability_set.main will be destroyed
  - resource "azurerm_availability_set" "main" {
      - id                           = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/availabilitySets/udacity-project1-vmset" -> null
      - location                     = "westeurope" -> null
      - managed                      = true -> null
      - name                         = "udacity-project1-vmset" -> null
      - platform_fault_domain_count  = 2 -> null
      - platform_update_domain_count = 5 -> null
      - resource_group_name          = "Azuredevops" -> null
      - tags                         = {
          - "create-by" = "congdinh2023"
        } -> null
    }

  # azurerm_lb.main will be destroyed
  - resource "azurerm_lb" "main" {
      - id                   = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/udacity-project1-lb" -> null
      - location             = "westeurope" -> null
      - name                 = "udacity-project1-lb" -> null
      - private_ip_addresses = [] -> null
      - resource_group_name  = "Azuredevops" -> null
      - sku                  = "Basic" -> null
      - sku_tier             = "Regional" -> null
      - tags                 = {
          - "create-by" = "congdinh2023"
        } -> null

      - frontend_ip_configuration {
          - availability_zone             = "No-Zone" -> null
          - id                            = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/udacity-project1-lb/frontendIPConfigurations/publicIPAddress" -> null
          - inbound_nat_rules             = [] -> null
          - load_balancer_rules           = [] -> null
          - name                          = "publicIPAddress" -> null
          - outbound_rules                = [] -> null
          - private_ip_address_allocation = "Dynamic" -> null
          - public_ip_address_id          = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/publicIPAddresses/vmss-public-ip" -> null
          - zones                         = [] -> null
        }
    }

  # azurerm_lb_backend_address_pool.main will be destroyed
  - resource "azurerm_lb_backend_address_pool" "main" {
      - backend_ip_configurations = [
          - "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-0/ipConfigurations/internal",
          - "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-1/ipConfigurations/internal",
        ] -> null
      - id                        = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/udacity-project1-lb/backendAddressPools/udacity-project1-BackEndAddressPool" -> null
      - load_balancing_rules      = [] -> null
      - loadbalancer_id           = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/udacity-project1-lb" -> null
      - name                      = "udacity-project1-BackEndAddressPool" -> null
      - outbound_rules            = [] -> null
      - resource_group_name       = "Azuredevops" -> null
    }

  # azurerm_linux_virtual_machine.main[0] will be destroyed
  - resource "azurerm_linux_virtual_machine" "main" {
      - admin_password                  = (sensitive value) -> null
      - admin_username                  = "congdinh2023" -> null
      - allow_extension_operations      = true -> null
      - availability_set_id             = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/availabilitySets/UDACITY-PROJECT1-VMSET" -> null
      - computer_name                   = "udacity-project1-vm-0" -> null
      - disable_password_authentication = false -> null
      - encryption_at_host_enabled      = false -> null
      - extensions_time_budget          = "PT1H30M" -> null
      - id                              = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/virtualMachines/udacity-project1-vm-0" -> null
      - location                        = "westeurope" -> null
      - max_bid_price                   = -1 -> null
      - name                            = "udacity-project1-vm-0" -> null
      - network_interface_ids           = [
          - "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-0",
        ] -> null
      - patch_mode                      = "ImageDefault" -> null
      - platform_fault_domain           = -1 -> null
      - priority                        = "Regular" -> null
      - private_ip_address              = "10.0.2.4" -> null
      - private_ip_addresses            = [
          - "10.0.2.4",
        ] -> null
      - provision_vm_agent              = true -> null
      - public_ip_addresses             = [] -> null
      - resource_group_name             = "Azuredevops" -> null
      - secure_boot_enabled             = false -> null
      - size                            = "Standard_B1s" -> null
      - source_image_id                 = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/images/udacity-ubuntu-server-image" -> null
      - tags                            = {
          - "create-by" = "congdinh2023"
        } -> null
      - virtual_machine_id              = "866bd410-d563-447d-b738-24d64d93dbaf" -> null
      - vtpm_enabled                    = false -> null

      - os_disk {
          - caching                   = "ReadWrite" -> null
          - disk_size_gb              = 30 -> null
          - name                      = "udacity-project1-vm-0_disk1_73c2f279e5f447d194c466cb78cc3b70" -> null
          - storage_account_type      = "Standard_LRS" -> null
          - write_accelerator_enabled = false -> null
        }
    }

  # azurerm_linux_virtual_machine.main[1] will be destroyed
  - resource "azurerm_linux_virtual_machine" "main" {
      - admin_password                  = (sensitive value) -> null
      - admin_username                  = "congdinh2023" -> null
      - allow_extension_operations      = true -> null
      - availability_set_id             = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/availabilitySets/UDACITY-PROJECT1-VMSET" -> null
      - computer_name                   = "udacity-project1-vm-1" -> null
      - disable_password_authentication = false -> null
      - encryption_at_host_enabled      = false -> null
      - extensions_time_budget          = "PT1H30M" -> null
      - id                              = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/virtualMachines/udacity-project1-vm-1" -> null
      - location                        = "westeurope" -> null
      - max_bid_price                   = -1 -> null
      - name                            = "udacity-project1-vm-1" -> null
      - network_interface_ids           = [
          - "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-1",
        ] -> null
      - patch_mode                      = "ImageDefault" -> null
      - platform_fault_domain           = -1 -> null
      - priority                        = "Regular" -> null
      - private_ip_address              = "10.0.2.5" -> null
      - private_ip_addresses            = [
          - "10.0.2.5",
        ] -> null
      - provision_vm_agent              = true -> null
      - public_ip_addresses             = [] -> null
      - resource_group_name             = "Azuredevops" -> null
      - secure_boot_enabled             = false -> null
      - size                            = "Standard_B1s" -> null
      - source_image_id                 = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/images/udacity-ubuntu-server-image" -> null
      - tags                            = {
          - "create-by" = "congdinh2023"
        } -> null
      - virtual_machine_id              = "d39c5022-2d01-49f7-bfdc-99bdef2dfcc0" -> null
      - vtpm_enabled                    = false -> null

      - os_disk {
          - caching                   = "ReadWrite" -> null
          - disk_size_gb              = 30 -> null
          - name                      = "udacity-project1-vm-1_disk1_7679493c137f42c89c8c9ef0d4e3108f" -> null
          - storage_account_type      = "Standard_LRS" -> null
          - write_accelerator_enabled = false -> null
        }
    }

  # azurerm_managed_disk.main will be destroyed
  - resource "azurerm_managed_disk" "main" {
      - create_option                 = "Empty" -> null
      - disk_iops_read_only           = 0 -> null
      - disk_iops_read_write          = 500 -> null
      - disk_mbps_read_only           = 0 -> null
      - disk_mbps_read_write          = 60 -> null
      - disk_size_gb                  = 1 -> null
      - id                            = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/disks/udacity-project1-md" -> null
      - location                      = "westeurope" -> null
      - max_shares                    = 0 -> null
      - name                          = "udacity-project1-md" -> null
      - on_demand_bursting_enabled    = false -> null
      - public_network_access_enabled = true -> null
      - resource_group_name           = "Azuredevops" -> null
      - storage_account_type          = "Standard_LRS" -> null
      - tags                          = {
          - "create-by" = "congdinh2023"
        } -> null
      - trusted_launch_enabled        = false -> null
      - zones                         = [] -> null
    }

  # azurerm_network_interface.main[0] will be destroyed
  - resource "azurerm_network_interface" "main" {
      - applied_dns_servers           = [] -> null
      - dns_servers                   = [] -> null
      - enable_accelerated_networking = false -> null
      - enable_ip_forwarding          = false -> null
      - id                            = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-0" -> null
      - internal_domain_name_suffix   = "fwhz2irg1m5efjypxvtswzgdkh.ax.internal.cloudapp.net" -> null
      - location                      = "westeurope" -> null
      - mac_address                   = "00-0D-3A-44-77-44" -> null
      - name                          = "udacity-project1-NIC-0" -> null
      - private_ip_address            = "10.0.2.4" -> null
      - private_ip_addresses          = [
          - "10.0.2.4",
        ] -> null
      - resource_group_name           = "Azuredevops" -> null
      - tags                          = {
          - "create-by" = "congdinh2023"
        } -> null
      - virtual_machine_id            = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/virtualMachines/udacity-project1-vm-0" -> null

      - ip_configuration {
          - name                          = "internal" -> null
          - primary                       = true -> null
          - private_ip_address            = "10.0.2.4" -> null
          - private_ip_address_allocation = "Dynamic" -> null
          - private_ip_address_version    = "IPv4" -> null
          - subnet_id                     = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/virtualNetworks/udacity-project1-vnet/subnets/udacity-project1-subnet" -> null
        }
    }

  # azurerm_network_interface.main[1] will be destroyed
  - resource "azurerm_network_interface" "main" {
      - applied_dns_servers           = [] -> null
      - dns_servers                   = [] -> null
      - enable_accelerated_networking = false -> null
      - enable_ip_forwarding          = false -> null
      - id                            = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-1" -> null
      - internal_domain_name_suffix   = "fwhz2irg1m5efjypxvtswzgdkh.ax.internal.cloudapp.net" -> null
      - location                      = "westeurope" -> null
      - mac_address                   = "00-0D-3A-44-7E-9B" -> null
      - name                          = "udacity-project1-NIC-1" -> null
      - private_ip_address            = "10.0.2.5" -> null
      - private_ip_addresses          = [
          - "10.0.2.5",
        ] -> null
      - resource_group_name           = "Azuredevops" -> null
      - tags                          = {
          - "create-by" = "congdinh2023"
        } -> null
      - virtual_machine_id            = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/virtualMachines/udacity-project1-vm-1" -> null

      - ip_configuration {
          - name                          = "internal" -> null
          - primary                       = true -> null
          - private_ip_address            = "10.0.2.5" -> null
          - private_ip_address_allocation = "Dynamic" -> null
          - private_ip_address_version    = "IPv4" -> null
          - subnet_id                     = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/virtualNetworks/udacity-project1-vnet/subnets/udacity-project1-subnet" -> null
        }
    }

  # azurerm_network_interface_backend_address_pool_association.main[0] will be destroyed
  - resource "azurerm_network_interface_backend_address_pool_association" "main" {
      - backend_address_pool_id = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/udacity-project1-lb/backendAddressPools/udacity-project1-BackEndAddressPool" -> null
      - id                      = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-0/ipConfigurations/internal|/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/udacity-project1-lb/backendAddressPools/udacity-project1-BackEndAddressPool" -> null
      - ip_configuration_name   = "internal" -> null
      - network_interface_id    = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-0" -> null
    }

  # azurerm_network_interface_backend_address_pool_association.main[1] will be destroyed
  - resource "azurerm_network_interface_backend_address_pool_association" "main" {
      - backend_address_pool_id = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/udacity-project1-lb/backendAddressPools/udacity-project1-BackEndAddressPool" -> null
      - id                      = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-1/ipConfigurations/internal|/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/udacity-project1-lb/backendAddressPools/udacity-project1-BackEndAddressPool" -> null
      - ip_configuration_name   = "internal" -> null
      - network_interface_id    = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-1" -> null
    }

  # azurerm_network_security_group.main will be destroyed
  - resource "azurerm_network_security_group" "main" {
      - id                  = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkSecurityGroups/udacity-project1-sg" -> null
      - location            = "westeurope" -> null
      - name                = "udacity-project1-sg" -> null
      - resource_group_name = "Azuredevops" -> null
      - security_rule       = [] -> null
      - tags                = {
          - "create-by" = "congdinh2023"
        } -> null
    }

  # azurerm_public_ip.main will be destroyed
  - resource "azurerm_public_ip" "main" {
      - allocation_method       = "Static" -> null
      - availability_zone       = "No-Zone" -> null
      - id                      = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/publicIPAddresses/vmss-public-ip" -> null
      - idle_timeout_in_minutes = 4 -> null
      - ip_address              = "13.69.121.248" -> null
      - ip_tags                 = {} -> null
      - ip_version              = "IPv4" -> null
      - location                = "westeurope" -> null
      - name                    = "vmss-public-ip" -> null
      - resource_group_name     = "Azuredevops" -> null
      - sku                     = "Basic" -> null
      - sku_tier                = "Regional" -> null
      - tags                    = {
          - "create-by" = "congdinh2023"
        } -> null
      - zones                   = [] -> null
    }

  # azurerm_resource_group.main will be destroyed
  - resource "azurerm_resource_group" "main" {
      - id       = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops" -> null
      - location = "westeurope" -> null
      - name     = "Azuredevops" -> null
      - tags     = {
          - "create-by" = "congdinh2023"
        } -> null

      - timeouts {}
    }

  # azurerm_subnet.main will be destroyed
  - resource "azurerm_subnet" "main" {
      - address_prefix                                 = "10.0.2.0/24" -> null
      - address_prefixes                               = [
          - "10.0.2.0/24",
        ] -> null
      - enforce_private_link_endpoint_network_policies = false -> null
      - enforce_private_link_service_network_policies  = false -> null
      - id                                             = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/virtualNetworks/udacity-project1-vnet/subnets/udacity-project1-subnet" -> null
      - name                                           = "udacity-project1-subnet" -> null
      - resource_group_name                            = "Azuredevops" -> null
      - service_endpoint_policy_ids                    = [] -> null
      - service_endpoints                              = [] -> null
      - virtual_network_name                           = "udacity-project1-vnet" -> null
    }

  # azurerm_virtual_network.main will be destroyed
  - resource "azurerm_virtual_network" "main" {
      - address_space           = [
          - "10.0.0.0/16",
        ] -> null
      - dns_servers             = [] -> null
      - flow_timeout_in_minutes = 0 -> null
      - guid                    = "229e8f2d-db26-423e-a70f-bd672b64c357" -> null
      - id                      = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/virtualNetworks/udacity-project1-vnet" -> null
      - location                = "westeurope" -> null
      - name                    = "udacity-project1-vnet" -> null
      - resource_group_name     = "Azuredevops" -> null
      - subnet                  = [
          - {
              - address_prefix = "10.0.2.0/24"
              - id             = "/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/virtualNetworks/udacity-project1-vnet/subnets/udacity-project1-subnet"
              - name           = "udacity-project1-subnet"
              - security_group = ""
            },
        ] -> null
      - tags                    = {
          - "create-by" = "congdinh2023"
        } -> null
      - vm_protection_enabled   = false -> null
    }

Plan: 0 to add, 0 to change, 15 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

azurerm_network_interface_backend_address_pool_association.main[0]: Destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-0/ipConfigurations/internal|/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/udacity-project1-lb/backendAddressPools/udacity-project1-BackEndAddressPool]
azurerm_network_security_group.main: Destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkSecurityGroups/udacity-project1-sg]
azurerm_network_interface_backend_address_pool_association.main[1]: Destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-1/ipConfigurations/internal|/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/udacity-project1-lb/backendAddressPools/udacity-project1-BackEndAddressPool]
azurerm_managed_disk.main: Destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/disks/udacity-project1-md]
azurerm_linux_virtual_machine.main[1]: Destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/virtualMachines/udacity-project1-vm-1]
azurerm_linux_virtual_machine.main[0]: Destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/virtualMachines/udacity-project1-vm-0]
azurerm_managed_disk.main: Destruction complete after 3s
azurerm_network_security_group.main: Destruction complete after 4s
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-.../virtualMachines/udacity-project1-vm-0, 10s elapsed]
azurerm_network_interface_backend_address_pool_association.main[0]: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-...ls/udacity-project1-BackEndAddressPool, 10s elapsed]
azurerm_network_interface_backend_address_pool_association.main[1]: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-...ls/udacity-project1-BackEndAddressPool, 10s elapsed]
azurerm_linux_virtual_machine.main[1]: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-.../virtualMachines/udacity-project1-vm-1, 10s elapsed]
azurerm_network_interface_backend_address_pool_association.main[1]: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-...ls/udacity-project1-BackEndAddressPool, 20s elapsed]
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-.../virtualMachines/udacity-project1-vm-0, 20s elapsed]
azurerm_network_interface_backend_address_pool_association.main[0]: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-...ls/udacity-project1-BackEndAddressPool, 20s elapsed]
azurerm_linux_virtual_machine.main[1]: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-.../virtualMachines/udacity-project1-vm-1, 20s elapsed]
azurerm_network_interface_backend_address_pool_association.main[0]: Destruction complete after 26s
azurerm_network_interface_backend_address_pool_association.main[1]: Destruction complete after 26s
azurerm_lb_backend_address_pool.main: Destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/udacity-project1-lb/backendAddressPools/udacity-project1-BackEndAddressPool]
azurerm_linux_virtual_machine.main[1]: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-.../virtualMachines/udacity-project1-vm-1, 30s elapsed]
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-.../virtualMachines/udacity-project1-vm-0, 30s elapsed]
azurerm_lb_backend_address_pool.main: Destruction complete after 5s
azurerm_lb.main: Destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/loadBalancers/udacity-project1-lb]
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-.../virtualMachines/udacity-project1-vm-0, 40s elapsed]
azurerm_linux_virtual_machine.main[1]: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-.../virtualMachines/udacity-project1-vm-1, 40s elapsed]
azurerm_lb.main: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-...work/loadBalancers/udacity-project1-lb, 10s elapsed]
azurerm_lb.main: Destruction complete after 11s
azurerm_public_ip.main: Destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/publicIPAddresses/vmss-public-ip]
azurerm_linux_virtual_machine.main[1]: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-.../virtualMachines/udacity-project1-vm-1, 50s elapsed]
azurerm_linux_virtual_machine.main[0]: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-.../virtualMachines/udacity-project1-vm-0, 50s elapsed]
azurerm_public_ip.main: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-...twork/publicIPAddresses/vmss-public-ip, 10s elapsed]
azurerm_linux_virtual_machine.main[1]: Destruction complete after 56s
azurerm_public_ip.main: Destruction complete after 14s
azurerm_linux_virtual_machine.main[0]: Destruction complete after 57s
azurerm_availability_set.main: Destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Compute/availabilitySets/udacity-project1-vmset]
azurerm_network_interface.main[0]: Destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-0]
azurerm_network_interface.main[1]: Destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/networkInterfaces/udacity-project1-NIC-1]
azurerm_network_interface.main[1]: Destruction complete after 8s
azurerm_availability_set.main: Destruction complete after 9s
azurerm_network_interface.main[0]: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-...tworkInterfaces/udacity-project1-NIC-0, 10s elapsed]
azurerm_network_interface.main[0]: Destruction complete after 14s
azurerm_subnet.main: Destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/virtualNetworks/udacity-project1-vnet/subnets/udacity-project1-subnet]
azurerm_subnet.main: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-...1-vnet/subnets/udacity-project1-subnet, 10s elapsed]
azurerm_subnet.main: Destruction complete after 13s
azurerm_virtual_network.main: Destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops/providers/Microsoft.Network/virtualNetworks/udacity-project1-vnet]
azurerm_virtual_network.main: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-.../virtualNetworks/udacity-project1-vnet, 10s elapsed]
azurerm_virtual_network.main: Destruction complete after 13s
azurerm_resource_group.main: Destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops, 10s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops, 20s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops, 30s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops, 40s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops, 50s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops, 1m0s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops, 1m10s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops, 1m20s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops, 1m30s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops, 1m40s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops, 1m50s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops, 2m0s elapsed]
azurerm_resource_group.main: Still destroying... [id=/subscriptions/bb90f4ea-a7ed-462c-abe0-20478893b26d/resourceGroups/Azuredevops, 2m10s elapsed]
azurerm_resource_group.main: Destruction complete after 2m11s

Destroy complete! Resources: 15 destroyed.
```