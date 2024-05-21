Terraform Configuration for Linode with NodeBalancer

This Terraform setup is designed to deploy multiple Linode instances and configure a NodeBalancer to distribute traffic among these instances. Below is a breakdown of the key components and configuration files used in this setup.

1. main.tf
This file contains the main Terraform configuration, defining the Linode provider and resources for the Linode instances and NodeBalancer.
2. output.tf
This file defines outputs for the IP addresses of the Linode instances and the NodeBalancer.
3. terraform.tfvars
This file contains variable values for the configuration. Sensitive information like tokens and passwords are typically stored here.
4. variables.tf
This file defines the variables used in the configuration.

Notes on Configuration
Provider Configuration: The provider "linode" block sets up the Linode provider with the API token provided via var.token_linode.
Linode Instances: The linode_instance resource creates multiple Linode instances based on the count specified in var.node_count. Each instance is labeled uniquely using count.index.
Connection and Provisioning: The connection block uses SSH to connect to the instances. Provisioners are used to upload a setup script (setup_script.sh) and execute it on each instance.
NodeBalancer: The linode_nodebalancer resource creates a NodeBalancer to distribute traffic. The configuration and nodes for the NodeBalancer are set up using linode_nodebalancer_config and linode_nodebalancer_node resources respectively.
Outputs: Outputs are defined to retrieve the private IP addresses of the Linode instances and the IP/hostname of the NodeBalancer.


Usage
Initialization: Run terraform init to initialize the Terraform working directory.
Plan: Use terraform plan to see a preview of the actions Terraform will take to achieve the desired state.
Apply: Execute terraform apply to create the resources defined in the configuration.
Ensure that the terraform.tfvars file is correctly populated with the necessary values before running the commands.
