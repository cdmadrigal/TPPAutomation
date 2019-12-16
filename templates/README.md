# Automate TPP Install will AWS CloudFormation

## Abstract
You have a few ways to deploy this project. First you need to make the choice if you want this in an existing VPC or a new one created with all of the artifacts. 
If you want to create new VPC with your deployment, deploy the "nested-vpc-tpp.json" file within CloudFormation. 
If you want to deploy all the artifacts within an existing VPC, you have a few choices but the easiest thing to do would be to deploy the "nested-novpc-tpp.json" file within CloudFormation.

If you want to explore the sub-templates more go in to the components folder, there you will find the template to deploy the MSQL server and tpp server.

## Getting Started
A few things you will need to run through this:

- An AWS account. Can't deploy a CloudFormation template without it :)
- A VPC with at least a public subnet and 2 private subnets. (For an existing deployment)
- Some basic AWS knowledge.

## Instructions
**Note:** These instructions are for a deployment on an existing VPC. If you want the instructions on deploying to a new VPC, jump down further below.

### Nested TPP + DB Install - Existing VPC
This template/instructions will call the two templates within the components folder and only ask you to configure all of the variables once. This is useful if you just want to create the DB and install TPP in one template. If you already have a running DB you want to use, go to the components folder and deploy the tpp-ec2-install.json file.

#### Step 1:
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

#### Step 2:
Go to the CloudFormation console and import the nested-novpc-tpp.json to it. Click next and this should bring up the configuration window. Let's what through this one by one.

- Stack Name: Name of the stack.
- Key Name: Key pair used to decrypt Windows password. Example - CrisKeyPair.pem
- Private CIDR Block 1 ID: CIDR block of the first private subnet in the VPC. Example - 10.0.1.0/24
- Private CIDR Block 2 ID: CIDR block of the second private subnet in the VPC. Example - 10.0.2.0/24
- Public CIDR Block 1 ID: CIDR block of the first public subnet in the VPC. Example - 10.0.16.0/24
- CIDR block of your VPC: This is the CIDR block that's defined/set for your VPC. Example - 10.0.0.0/16
- ID of VPC: The actual VPC ID you will be deploying this application to. Example - vpc-0579f9cb9c2a
- Size of Microsoft SQL server: Defaults to 25 GiB, but this can any value.
- Microsoft SQL server class type: Defaults to db.t2.medium but this can be changed to any of the values in the drop down.
  
**Note:** Your Microsoft SQL server admin and Microsoft SQL server service user are different people. The server admin is the master or the DBA. The service user is the user we will use to manage and access the database within TPP. Best practices dictate that we don't use a master/admin account for this.  

- DBMasterUsername: DBA of your SQL server. This must match the DBA account of your database, if not this will cause the template to fail. Example - sqladmin
- DBMasterUserPassword: Password of your DBA account. This must match the password of the DBA on the database you will be using, if not this will cause the template to fail. Example - sql-passw0rd
- DBMasterUserPassword (Confirm): Confirmation of your password of your DBA account. This must match the password of the DBA on the database you will be using, if not this will cause the template to fail. Example - sql-passw0rd
- DBServiceUsername: Username of the service user for your SQL server. If your database has already been preconfigured, this service account entered here must match the one that exists on the DB. If it has not been configured (not from a snapshot), then feel free to enter whatever you want here. Example - serviceuser
- DBServiceUserPassword: Password of the service user for your SQL server. If your database has already been preconfigured, this service account password entered here must match the password of the service account on the DB. If it has not been configured (not from a snapshot), then feel free to enter whatever you want here. Example - service-passw0rd
- DBServiceUserPassword (Confirm): Confirmation of the password of the service user for your SQL server. If your database has already been preconfigured, this service account password entered here must match the password of the service account on the DB. If it has not been configured (not from a snapshot), then feel free to enter whatever you want here. Example - service-passw0rd
- SnapshotID: Optional. Only use this if you wish to restore a snapshot for this database. This snapshot must be already configured with the proper scripts to run TPP.
- TPPAdminAccount: Username of TPP admin. Example - tppadmin
- TPPAdminAccountPassword: Password of TPP admin. Example - tpp-passw0rd-Test
- TppAdminAccountPassword (Confirm): Confirmation of TPP admin password. Example - tpp-passw0rd-Test
- Microsoft Server ID: This defaults to the Windows base 2016 server image provided by AWS.
- AnswerFile: URL of where the updated Answerfile is located. Example - https://sample-bucket-public.s3.amazonaws.com/answerfile.xml 
- VenafiUserLogin: Username of account used to access Venafi's download server. Example - cris.madrigal@venafi.com
- VenafiUserPass: Password of account used to access Venafi's download server. Example - my-passw0rd-D0wnl0ad
- VenafiUserPassword (Confim): Password of account used to access Venafi's download server. Example - my-passw0rd-D0wnl0ad

#### Step 3:
Once you've filled in all the parameters, hit next till you get to a review screen. You should see all the parameters you've entered. You passwords will be hidden. Once you've reviewed everything, click on "Create Stack" down below.

#### Step 4: 
**Note:** The creation of the nested stacks will take around 20 minutes but about another 40 to 50 minutes will be needed for all the dependencies and TPP to be installed. So please be patient.

If you set the 'ServiceStart' parameter in the Answerfile to 'yes', you should have your tpp instance running and accessible. To access the vedadmin or aperture GUI, check the outputs of the Cloudformation template. If everything is working properly, you should see a login page, enter the credentials for your TPP admin you created. Remember this may take 40 minutes. 


### Nested TPP + DB Deployement - New VPC
This template calls the nested template from above and a VPC creation template managed by AWS. It uses both of these to deploy all of the componenets within the newly created VPC. This is particularly useful if you are a first time Venafi/AWS user as you dont need to worry about the networking configurations of your existing VPC.

#### Step 1
With your favorite text editor open up the answerfile. There are a few things that you can change, and a few things that you should NOT change. Values you can safely change:

- Products
- Features
- LogExpiration
- CompanyName
- DeploymentType
- StartServices

If you are planning to connect this TPP server to a preconfigured database, you will need to add the software encryption key to the answerfile. This is important, if this isn't done you will get an error saying that it can't connect to the DB.

Do not change anyhting else in the answerfile. Also note how the different listed Products and Features are formatted. This is important, your deployment may be incomplete if your introduce whitespace between the different products and features. 
Once you're happy with the changes you've made, save the file and store it somewhere that can accessed via the powershell Invoke-WebRequest command. Some suitable places may be a public S3 bucket or public Git repository. At no point should your answerfile have your credentials hardcoded in it.

#### Step 2
Go to the CloudFormation console and import the nested-vpc-tpp.json to it. Click next and this should bring up the configuration window. Let's walk through this one by one.

- Stack Name: Name of the stack.
- Key Pair: Key pair used to decrypt Windows password. Example - CrisKeyPair.pem
- Private Subnet 1 CIDR Block: CIDR block for private subnet 1. I suggest leaving this as the default value. Example - 192.168.128.0/24
- Private Subnet 2 CIDR Block: CIDR block for private subnet 2. I suggest leaving this as the default value. Example - 192.168.192.0/24
- Public Subnet 1 CIDR Block: CIDR block for public subnet 1. I suggest leaving this as the default value. Example - 192.168.0.0/24
- Public Subnet 2 CIDR Block: CIDR block for public subnet 2. I suggest leaving this as the default value. Example - 192.168.64.0/24
- VPC CIDR Block: The CIDR range of your VPC. I suggest leaving this as the default value. Example - 192.168.0.0/16
- Storage size of Microsoft SQL server:  Defaults to 25 GiB, but this can any value.
- Microsoft SQL server class type: Defaults to db.t2.medium but this can be changed to any of the values in the drop down.
  
**Note:** Your Microsoft SQL server admin and Microsoft SQL server service user are different people. The server admin is the master or the DBA. The service user is the user we will use to manage and access the database within TPP. Best practices dictate that we don't use a master/admin account for this.  

- DBMasterUsername: DBA of your SQL server. This must match the DBA account of your database, if not this will cause the template to fail. Example - sqladmin
- DBMasterUserPassword: Password of your DBA account. This must match the password of the DBA on the database you will be using, if not this will cause the template to fail. Example - sql-passw0rd
- DBMasterUserPassword (Confirm): Confirmation of your password of your DBA account. This must match the password of the DBA on the database you will be using, if not this will cause the template to fail. Example - sql-passw0rd
- DBServiceUsername: Username of the service user for your SQL server. If your database has already been preconfigured, this service account entered here must match the one that exists on the DB. If it has not been configured (not from a snapshot), then feel free to enter whatever you want here. Example - serviceuser
- DBServiceUserPassword: Password of the service user for your SQL server. If your database has already been preconfigured, this service account password entered here must match the password of the service account on the DB. If it has not been configured (not from a snapshot), then feel free to enter whatever you want here. Example - service-passw0rd
- DBServiceUserPassword (Confirm): Confirmation of the password of the service user for your SQL server. If your database has already been preconfigured, this service account password entered here must match the password of the service account on the DB. If it has not been configured (not from a snapshot), then feel free to enter whatever you want here. Example - service-passw0rd
- SnapshotID: Optional. Only use this if you wish to restore a snapshot for this database. This snapshot must be already configured with the proper scripts to run TPP.
- TPPAdminAccount: Username of TPP admin. Example - tppadmin
- TPPAdminAccountPassword: Password of TPP admin. Example - tpp-passw0rd-Test
- TppAdminAccountPassword (Confirm): Confirmation of TPP admin password. Example - tpp-passw0rd-Test
- Microsoft Server ID: This defaults to the Windows base 2016 server image provided by AWS.
- AnswerFile: URL of where the updated Answerfile is located. Example - https://sample-bucket-public.s3.amazonaws.com/answerfile.xml 
- VenafiUserLogin: Username of account used to access Venafi's download server. Example - cris.madrigal@venafi.com
- VenafiUserPass: Password of account used to access Venafi's download server. Example - my-passw0rd-D0wnl0ad
- VenafiUserPassword (Confim): Password of account used to access Venafi's download server. Example - my-passw0rd-D0wnl0ad

#### Step 3
Once you've filled in all the parameters, hit next till you get to a review screen. You should see all the parameters you've entered. You passwords will be hidden. Once you've reviewed everything, click on "Create Stack" down below.

#### Step 4
**Note:** The creation of the nested stacks will take around 30 minutes but about another 40 to 50 minutes will be needed for all the dependencies and TPP to be installed. So please be patient.

If you set the 'ServiceStart' parameter in the Answerfile to 'yes', you should have your tpp instance running and accessible. To access the vedadmin or aperture GUI, check the outputs of the Cloudformation template. If everything is working properly, you should see a login page, enter the credentials for your TPP admin you created. Remember this may take 40 minutes. 
