# Automate TPP Install with CloudFormation on AWS

## Abstract
Often times when we show TPP demos on AWS we use pre build AMIs that have all the dependencies installed. This is relatively easy to use and is quick to spin up. But in certain scenarios you will want a fresh install of TPP on a base Windows Server 2016. Some of these reasons may be: 

- You don't want to bother updating the AMI to the newest version of TPP. You just want a fresh install from scratch.
- You have a requirement to not use a pre-build AMI, this is particularly useful in customer environments where they won't have access to the pre-built AMI you have created.
- This fits the DevOps story. Spin up and destroy TPP instances with a template without much setup (Only entering a few parameters). Automate everything.
- You need short lived, test TPP environments.

## Getting Started
A few things you will need to run through this:

- An AWS account. Can't deploy a CloudFormation template without it :)
- Access to the Venafi download server. You will need to enter your Username and password in the template to download the required files from there.
- Knowledge of how to configure an answerfile.xml
- A Key Pair for the region you want to deploy these resources to. This is needed to generate a password to RDP in to your Windows server.
- A VPC with at least 2 public subnets and 2 private subnets.

## Navigating this Repository
The repository has a template folder has everything you need to deploy a TPP server from end to end. These templates are broken apart so you can deploy individual components seperately. 

There's a more indepth README file in the templates folder with deployment instructions.
