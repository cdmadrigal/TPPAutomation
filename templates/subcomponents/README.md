# Automate TPP Install with AWS CloudFormation

## Abstract
The subcomponents folder houses templates that are used within the nested templates. These templates can also be deployed seperately. If you're a beginner just testing out these templates, I suggest you go back to the nested templates and deploy one of those.

At the moment there are only two templates housed within this folder, msql-db-install.json and tpp-ec2-install.json

## Microsoft SQL server 
This template creates a Microsoft SQL server for you. In most cases, this MSSQL server will be a clean install but the template does give you an option to restore from a snapshot. You can only deploy the MSSQL server within an existing VPC that has at least two private subnets.

### Step 1:
There are a few parameters we will need to fill in if we choose to use this template seperately: 

#### Network Configuration:
- Private CIDR Block 1 ID: ID of a private subnet within your VPC.
- Private CIDR Block 2 ID: ID of a private subnet within your VPC.
- CIDR of VPC: CIDR block of VPC being used.
- ID of VPC: ID of your existing VPC.

#### TPP Database Setup
- Size of Microsoft SQL server: Amount of storage you want for your MSSQL RDS instance. Default is 25 GiB.
- Microsoft SQL server class type: Class type of MSSQL RDS instance. Defaults to db.t2.medium but can be changed with the dropdown menu. 
- DBMasterUsername: DBA of your MSSQL server. Example - sqladmin
- DBMasterUserPassword: Password for your DBA. Example - sql-passw0rd
- DBMasterUserPassword (Confirm): Confirmation of the password for your DBA. Example - sql-passw0rd
- Snapshot ID: Only needs to be filled in if you're restoring the DB from a snapshot. For most users, you will want to leave this blank.

### Step 2: 
Once all the parameters are filled, click on next till you get to a review screen. Deploy once you double check to make sure all your parameters are okay.

### Step 3:
The deployment process will take about 15 minutes. You will know it's done when Cloudformation signals complete.

## TPP EC2 Install
This template creates an EC2 instance with TPP and all the necessary dependencies installed. You will need to provide a MSSQL as the backend.

### Step 1: 
We will skip a lot of the parameters that were covered in the nested stack README. If you have futher questions about the parameters please check out that README. 
Here we will go over the parameters that are different from the nested templates.

- Database Snapshot used?: This is a Yes or No choice. If you created your MSSQL db from a snapshot that already was configured with the necessary DB scripts to run TPP, set this value to 'Yes'. If not, set this to 'No'. 
  **Note:** This configuration is really important. If you don't fully understand it and choose the wrong choice, your deployment will fail.
- URL for Microsoft SQL server: URL of your MSSQL instance.
- Port for Microsoft SQL server: Defaults to 1433. Don't change this unless you have a custom port set for your MSSQL instance.

### Step 2: 
Once all the parameters are filled, click on next till you get to a review screen. Deploy once you double check to make sure all your parameters are okay.

### Step 3: 
The deployment process will take about 35 minutes. You will know it's done when Cloudformation signals complete.

## Final Thoughts
This README serves to provide users with information about the subcomponent templates and how you can deploy them seperately if needed. Once again, we suggest that if you want to deploy the full stack, use the nested templates.