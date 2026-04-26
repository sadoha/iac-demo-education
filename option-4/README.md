
# Getting Started

> [!CAUTION]
> In the example below, the suggested environments are provided for educational purposes only and must not be used in production.

> [!IMPORTANT]
> Requirements
> * [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
> * [Azure account](https://azure.microsoft.com/en-us/get-started/azure-portal)

## Option 4

> [!NOTE]
> The fourth option is designed to demonstrate the proper directory structure and the use of modules. This approach showcases how to quickly spin up different environments by leveraging various modules.
> Storing the Terraform state file in an Azure Storage account allows teams to collaborate safely by using a centralized, secure remote backend. This is managed through the azurerm backend type, which stores the state as a blob within a container. 
> ### Why Use Azure Storage for State?
> * State Locking: Prevents concurrent runs from corrupting the state file by using Azure Blob leases to lock the file during active operations.
> * Encryption: State files, which may contain sensitive plain-text data, are encrypted at rest by Azure.
> * Collaboration: Multiple developers can share the same state, ensuring a single source of truth for the infrastructure.
> ### Terraform directories layout
> ```
> option-4
> ├── environments
> │   ├── dev
> │   │   ├── main.tf
> │   │   ├── outputs.tf
> │   │   ├── providers.tf
> │   │   ├── README.md
> │   │   └── variables.tf
> │   ├── prod
> │   │   ├── main.tf
> │   │   ├── outputs.tf
> │   │   ├── providers.tf
> │   │   ├── README.md
> │   │   └── variables.tf
> │   └── test
> │       ├── main.tf
> │       ├── outputs.tf
> │       ├── providers.tf
> │       ├── README.md
> │       └── variables.tf
> ├── global
> │   ├── main.tf
> │   ├── outputs.tf
> │   ├── providers.tf
> │   ├── README.md
> │   └── variables.tf
> ├── modules
> │   ├── load-balancer
> │   │   ├── main.tf
> │   │   ├── outputs.tf
> │   │   ├── README.md
> │   │   └── variables.tf
> │   ├── nat-gateway
> │   │   ├── main.tf
> │   │   ├── outputs.tf
> │   │   ├── README.md
> │   │   └── variables.tf
> │   ├── network
> │   │   ├── main.tf
> │   │   ├── outputs.tf
> │   │   ├── README.md
> │   │   └── variables.tf
> │   ├── resource-group
> │   │   ├── main.tf
> │   │   ├── outputs.tf
> │   │   ├── README.md
> │   │   └── variables.tf
> │   ├── security-group
> │   │   ├── main.tf
> │   │   ├── outputs.tf
> │   │   ├── README.md
> │   │   └── variables.tf
> │   ├── virtual-machine
> │   │   ├── main.tf
> │   │   ├── outputs.tf
> │   │   ├── README.md
> │   │   └── variables.tf
> │   └── virtual-machine-bastion
> │       ├── main.tf
> │       ├── outputs.tf
> │       ├── README.md
> │       └── variables.tf
> └── README.md
```

![screenshot](images/option-4.drawio.png)

## Installation

> [!NOTE]
> To deploy the environment, you need to run the commands listed below. However, make sure you have Terraform installed on your PC first.
---
The first thing you need to do is navigate to the directory containing your Terraform scripts.
```
cd IaC-demo-education/option-3
```
---
$${\color{red}terraform \space init}$$ is the command used to initialize a working directory containing Terraform configuration files. It is the foundation of the Terraform workflow and must be run before any other commands, such as plan or apply, can be executed
```
terraform init
```
---
$${\color{red}terraform \space plan}$$ is a primary command in the Terraform workflow that generates a speculative execution plan. It allows you to preview exactly what changes Terraform will make to your infrastructure before actually applying them. 
```
terraform plan
```
---
$${\color{red}terraform \space apply}$$ is a fundamental Terraform CLI command used to execute the operations required to reach the desired state defined in your configuration files. It is the step in the Terraform workflow where infrastructure is actually created, modified, or destroy.
```
terraform apply
```


