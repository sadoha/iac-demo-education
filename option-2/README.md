
# Getting Started

> [!CAUTION]
> In the example below, the suggested environments are provided for educational purposes only and must not be used in production.

> [!IMPORTANT]
> Requirements
> * [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
> * [Azure account](https://azure.microsoft.com/en-us/get-started/azure-portal)

## Option 1

> [!NOTE]
> The second example is very similar to the first, with the key difference being how the code is made more versatile. When you need to create multiple similar virtual machines, it is logical to use loops and reuse the same code. This example also demonstrates how to avoid code duplication.

![screenshot](images/option-2.drawio.png)

## Installation

> [!NOTE]
> To deploy the environment, you need to run the commands listed below. However, make sure you have Terraform installed on your PC first.
---
The first thing you need to do is navigate to the directory containing your Terraform scripts.
```
cd IaC-demo-education/option-2
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


