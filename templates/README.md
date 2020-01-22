# Automate TPP Install with AWS CloudFormation

## Abstract
You have a few ways to deploy this project. First you need to make the choice if you want this in an existing VPC or a new one created with all of the artifacts. 
If you want to create new VPC with your deployment, deploy the "nested-vpc-tpp.json" file within CloudFormation. 
If you want to deploy all the artifacts within an existing VPC, you have a few choices but the easiest thing to do would be to deploy the "nested-novpc-tpp.json" file within CloudFormation.

Second, make a choice if you're going to use Microsoft Active Directory to manage user accounts or you will manage everything with local users. 

If you want to explore the sub-templates more go in to the components folder, there you will find the template to deploy the MSQL server and tpp server.

## Getting Started
A few things you will need to run through this:

- An AWS account. Can't deploy a CloudFormation template without it :)
- A VPC with at least a public subnet and 2 private subnets. (For an existing deployment)
- Some basic AWS knowledge.

## Instructions
**Note:** These instructions cover both templates. Some of the parameters are different, we call those out below. 

### Step 1:
With your favorite text editor open up the answerfile. There are a few things that you can change, and a few things that you should NOT change. Values you can safely change:

- Products
- Features
- LogExpiration
- CompanyName
- DeploymentType
- StartServices

If you are planning to connect this TPP server to a preconfigured database, you will need to add the software encryption key to the answerfile. This is important, if this isn't done you will get an error saying that it can't connect to the DB.

Do not change anything else in the answerfile. Also note how the different listed Products and Features are formatted. This is important, your deployment may be incomplete if your introduce whitespace between the different products and features. 
Once you're happy with the changes you've made, save the file and store it somewhere that can accessed via the powershell Invoke-WebRequest command. Some suitable places may be a public S3 bucket or public Git repository. At no point should your answerfile have your credentials hardcoded in it.

### Step 2:
Go to the CloudFormation console and import the nested JSON file you want to use. Click next and this should bring up the configuration window. We will walk through different parameters you should fill.

#### General Configuration:
- GitHub Account Name: Name of your GitHub account hosting the repository that has all the necessary files. This defaults to cdmadrigal.
- GitHub Branch Name: Name of the working branch you want to use.
- GitHub Repository Name: Name of the GitHub repository that has all the project files in. Defaults to TPPAutomation.

#### Network Configuration: 
If you're using the nested template that creates a VPC for you, most of these parameters will be filled in for you. All you have to do is set the AZs and Key Pair you want to use. 
If you are planning to use your own VPC, there are a few things you need to fill out. Set the CIDR blocks correctly, you will need to define the ID's for two private subnets and 1 public subnet. Also fill in the CIDR block of the VPC you want to use and the ID of that VPC.

#### Microsoft AD Setup:
**Note:** If you wish to setup Microsoft AD within the deployed instance set the `Install Microsoft AD Confirmation` parameter to 'Yes'. If you wish to only use local users, set the parameter to 'No', dont fill in any of the Microsoft AD password parameters and skip to the TPP Database setup section below.

- Install Microsoft AD Confirmation: Yes or No value. Yes means you want to use AD within the EC2 instance. No means you wish to only use local users.
- Microsoft Active Directory User: Username of the AD admin. 
- Microsoft Active Directory Password: Password of the AD admin. Must contain a lowercase, uppercase, digit, special character and be longer than 12 characters.
- Microsoft Active Directory Password (Confirm): Confirmation of AD admin password.
- Microsoft Active Directory safe mode recovery password: Password used to recover AD within safe mode. Must contain a lowercase, uppercase, digit, special character and be longer than 12 characters.
- Microsoft Active Directory safe mode recovery password (Confirm): Confirmation of safe mode recovery password.
- Microsoft Active Directory domain name: The domain you want your Active Directory to use.
- Microsoft Active Directory netbios name: Netbios name you want to use for your AD.

#### TPP Database Setup:
- Size of Microsoft SQL server: Amount of storage you want for your MSSQL RDS instance. Default is 25 GiB.
- Microsoft SQL server class type: Class type of MSSQL RDS instance. Defaults to db.t2.medium but can be changed with the dropdown menu. 
- DBMasterUsername: DBA of your MSSQL server. Example - sqladmin
- DBMasterUserPassword: Password for your DBA. Example - sql-passw0rd
- DBMasterUserPassword (Confirm): Confirmation of the password for your DBA. Example - sql-passw0rd
- DBServiceUsername: Username of service user in MSSQL server. Example - serviceuser
- DBServiceUserPassword: Password for your service user. Example - service-passw0rd
- DBServiceUserPassword (Confirm): Confirmation of service user password. Example - service-passw0rd
- Snapshot ID: Only needs to be filled in if you're restoring the DB from a snapshot. For most users, you will want to leave this blank.

#### TPP Server Setup: 
- TPP Admin Username: Username of TPP admin. Example - tppadmin
- TPPAdminAccountPassword: Password of TPP admin. Example - tpp-passw0rd-Test
- TPPAdminAccountPassword (Confirm): Confirmation of TPP admin password. Example - tpp-passw0rd-Test
- Microsoft Server ID: Default is set to the Windows Microsoft Server 2016 image path.
- AnswerFile.xml URL location: URL of where the updated Answerfile is located. Example -  https://sample-bucket-public.s3.amazonaws.com/answerfile.xml
- Instance Type of TPP server: Defaults to t2.large. Can be changed with the dropdown if needed.
- Volume size of TPP server instance: Defaults to 40 GiB. Amount of storage space you want for your EC2 instance.
- Venafi account username: Username of account used to access Venafi's download server. Example - cris.madrigal@venafi.com
- Venafi account password: Password of account used to access Venafi's download server. Example - my-passw0rd-D0wnl0ad
- Venafi account password (confirm): Confirmation of password for Venafi account. Example - my-passw0rd-D0wnL0ad

### Step 3:
Once you've filled in all the parameters, hit next till you get to a review screen. You should see all the parameters you've entered. You passwords will be hidden. Once you've reviewed everything, click on "Create Stack" down below.

### Step 4: 
This entire process will take about 45 minutes. You will know it's done when Cloudformation signals complete.

