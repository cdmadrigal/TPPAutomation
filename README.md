# Automate TPP Install with CloudFormation on AWS

## Abstract
Often times when we show TPP demos on AWS we use pre build AMIs that have all the dependencies installed. This is relatively easy to use and is quick to spin up. But in certain scenarios you will want a fresh install of TPP on a base Windows Server 2016. Some of these reasons may be: 

- You don't want to bother updating the AMI to the newest version of TPP. You just want a fresh install from scratch.
- You have a requirement to not use a pre-build AMI, this is particularly useful in customer environments where they won't have access to the pre-built AMI you have created.
- This fits the DevOps story. Spin up and destroy TPP instances with a template without much setup (Only entering a few parameters). Automate everything.
- You need short lived, test TPP environments.

This setup currently supports the following:
- Creation of a new MSSQL RDS instance or restoration from an existing snapshot.
- 90% of the Microsoft AD setup for TPP. The final 10% is a manual process that can't be avoided.
- Creation of a TPP server, this can either be added to an existing TPP cluster or brand new one.

## Getting Started
A few things you will need to run through this:

- An AWS account. Can't deploy a CloudFormation template without it :)
- Access to the Venafi download server. You will need to enter your Username and password in the template to download the required files from there.
- Knowledge of how to configure an answerfile.xml
- A Key Pair for the region you want to deploy these resources to. This is needed to generate a password to RDP in to your Windows server.
- A VPC with at least 2 public subnets and 2 private subnets.

## Navigating this Repository
The repository has a template folder that stores two nested templates, one for a deployment with an existing VPC and one for a deployment with a new VPC. Within the template folder, there's a subcomponents folder that contains templates for the MSSQL and EC2-TPP deployment. These are used by the nested templates to deploy all the artifacts and services.

There is also a folder with various powershell scripts. At the moment all of these scripts are used only when you are setting up Microsoft AD, in the future as these templates grow more powershell scripts will be added.

A sample answerfile exists that can be used edited and used to deploy your TPP instance. Keep proper XML formatting and don't introduce whitespace.

