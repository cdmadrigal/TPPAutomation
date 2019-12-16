# Automate TPP Install will AWS CloudFormation

## Abstract
This README will document the functionality of the msql-db-install.json and tpp-ec2-install.json files. This is useful if you are looking to deploy individual components. 
Here's an example: you already have a DB setup for TPP, so you only need to deploy the TPP portion of the setup. In that case, you would just use the tpp-ec2-install.json to deploy TPP to the VPC that your existing DB is sitting in.

## Instructions

### Microsoft SQL DB install
**Note:** Following these instructions will only deploy the Microsoft SQL server from a snapshot or scratch.

#### Step 1:
Go to the CloudFormation console and import the msql-db-install.json file to it. Click next and this should bring up the configuration window. Let's go over each parameter one by one.

**Note:** Your parameter values will be different for your deployment. Don't copy what you see here, just use it as a reference.

- Stack name: This should be some string that identifies the stack to yourself and its function. Example - cris-msql-db
- Private CIDR Block 1 ID: CIDR block of the first private subnet in the VPC. Example - 10.0.1.0/24
- Private CIDR Block 2 ID: CIDR block of the second private subnet in the VPC. Example - 10.0.2.0/24
- CIDR block of your VPC: This is the CIDR block that's defined/set for your VPC. Example - 10.0.0.0/16
- ID of VPC: The actual VPC ID you will be deploying this application to. Example - vpc-0579f9cb9c2a
- Size of Microsoft SQL server: Defaults to 25 GiB, but this can any value.
- Microsoft SQL server class type: Defaults to db.t2.medium but this can be changed to any of the values in the drop down.

**Note:** Your Microsoft SQL server admin will be your DBA. Once these values are set, there won't be a way to recover the password if you forget it.

- DBMasterUsername: DBA of your SQL server. Example - sqladmin
- DBMasterUserPassword: Password of DBA for your SQL server. Example - sql-passw0rd
- DBMasterUserPassword (Confirm): Confirmation of your DBA password. Example - sql-passw0rd
- SnapshotID: Optional. Only use this if you wish to restore a snapshot for this database. Keep in mind if this snapshot has already been configured for TPP. This will be important later on.

#### Step 2:
Once you've filled in all the parameters, hit next till you get to the review screen. You should see all the parameters you've entered. Your passwords will be hidden. Once you've reviewed everything, click on "Create Stack" down below.

#### Step 3:
The template will take about 15 minutes to deploy (may take longer if you're restoring a snapshot). Once the template is done, you should see a newly create MSQL DB within RDS. Keep in mind that this DB is not publicly accesssibly, so it can only be accessed within the VPC it's deployed in.

**Note:** If you wish to deploy a TPP server, continue down to the instructions below. This isn't a requirement, you can choose to just use the MSQL DB for other usecases, that's the beauty of the fragmented templates :)


### TPP Install
**Note:** These instructions are for a deployment on an existing VPC. These intructions only work if you have a DB you want to use already created previously. This DB can already be configured with the necessary scripts or clean. Once this template is completed, you will have a TPP instance deployed and connected to an existing DB.

#### Step 1: 
With your favorite text editor open up the answerfile. There are a few things that you can change, and a few things that you should NOT change. Values you can safely change:

- Products
- Features
- LogExpiration
- CompanyName
- DeploymentType
- StartServices

If you are planning to connect this TPP server to a preconfigured database, you will need to add the software key to the answerfile. This is important, if this isn't done you will get an error saying that it can't connect to the DB.

Do not change anyhting else in the answerfile. Also note how the different listed Products and Features are formatted. This is important, your deployment may be incomplete if your introduce whitespace between the different products and features. 
Once you're happy with the changes you've made, save the file and store it somewhere that can accessed via the powershell Invoke-WebRequest command. Some suitable places may be a public S3 bucket or public Git repository. At no point should your answerfile have your credentials hardcoded in it.

#### Step 2:
Go to the CloudFormation console and import the tpp-ec2-install.json to it. Click next and this should bring up the configuration window. Let's go over each parameter one by one.

**Note:** Your parameter values will be different for your deployment. Don't copy what you see here, just use it as a reference. 

- Key Pair: Key Pair to generate password to RDP in to the EC2 instance if needed.
- Private CIDR Block 1 ID: CIDR block of the first private subnet in the VPC. Example - 10.0.1.0/24
- Public CIDR Block 1 ID: CIDR block of the first public subnet in the VPC. Example - 10.0.16.0/24
- CIDR block of your VPC: This is the CIDR block that's defined/set for your VPC. Example - 10.0.0.0/16
- ID of VPC: The actual VPC ID you will be deploying this application to. Example - vpc-0579f9cb9c2a

**Note:** Your Microsoft SQL server admin and Microsoft SQL server service user are different people. The server admin is the master or the DBA. The service user is the user we will use to manage and access the database within TPP. Best practices dictate that we don't use a master/admin account for this.  

- DBMasterUsername: DBA of your SQL server. This must match the DBA account of your database, if not this will cause the template to fail. Example - sqladmin
- DBMasterUserPassword: Password of your DBA account. This must match the password of the DBA on the database you will be using, if not this will cause the template to fail. Example - sql-passw0rd
- DBMasterUserPassword (Confirm): Confirmation of your password of your DBA account. This must match the password of the DBA on the database you will be using, if not this will cause the template to fail. Example - sql-passw0rd
- DBServiceUsername: Username of the service user for your SQL server. If your database has already been preconfigured, this service account entered here must match the one that exists on the DB. If it has not been configured (not from a snapshot), then feel free to enter whatever you want here. Example - serviceuser
- DBServiceUserPassword: Password of the service user for your SQL server. If your database has already been preconfigured, this service account password entered here must match the password of the service account on the DB. If it has not been configured (not from a snapshot), then feel free to enter whatever you want here. Example - service-passw0rd
- DBServiceUserPassword (Confirm): Confirmation of the password of the service user for your SQL server. If your database has already been preconfigured, this service account password entered here must match the password of the service account on the DB. If it has not been configured (not from a snapshot), then feel free to enter whatever you want here. Example - service-passw0rd
- Database Snapshod Used?: If you used a snapshot to configure your DB and it's been configured with the necessary scripts to setup the DB, select 'Yes'. If the DB that exists hasnt been configured (clean creation), select 'No'.
- URL for Microsoft SQL server: URL of MSQL DB. Example - cteisjhfnwuoc3.c9jir3rsactr.us-east-1.rds.amazonaws.com 
- Port for Microsoft SQL server: The default is 1433. Leave this unchanged unless your database uses a different port.
- TPPAdminAccount: Username of TPP admin. Example - tppadmin
- TPPAdminAccountPassword: Password of TPP admin. Example - tpp-passw0rd-Test
- TppAdminAccountPassword (Confirm): Confirmation of TPP admin password. Example - tpp-passw0rd-Test
  
**Note:** The answerfile parameter (configured below) needs to filled with the answerfile you edited in the first step. This answerfile must be in a location that is accessible to the CloudFormation template. The easiest way to do this is storing it in a public S3 bucket or Git repo. Also, remember no hardcoded usernames, passwords or URLs should be stored in this file.

- TPPAnswerfile: URL to answerfile.xml location. Example - https://sample-bucket-public.s3.amazonaws.com/answerfile.xml 
- VenafiUserLogin: Username of account used to access Venafi's download server. Example - cris.madrigal@venafi.com
- VenafiUserPass: Password of account used to access Venafi's download server. Example - my-passw0rd-D0wnl0ad
- VenafiUserPassword (Confim): Password of account used to access Venafi's download server. Example - my-passw0rd-D0wnl0ad

#### Step 3: 
Once you've filled in all the parameters, hit next till you get to a review screen. You should see all the parameters you've entered. You passwords will be hidden. Once you've reviewed everything, click on "Create Stack" down below.

#### Step 4: 
**Note:** The Cloudformation template will take about 2-3 minutes to complete. But all the scripts within the EC2 instance will cause the TPP server to take about 30 to 40 minutes after the Cloudformation template signals complete.

If you set the 'ServiceStart' parameter in the Answerfile to 'yes', you should have your tpp instance running and accessible. To access the vedadmin or aperture GUI, check the outputs of the Cloudformation template. If everything is working properly, you should see a login page, enter the credentials for your TPP admin you created. Remember this may take 40 minutes. 

## Final Thoughts
For the most part you won't be deploying these templates individually as a first time deployment, these would probably added as suppliments to an existing full deployment in the future. That being said, it's always nice to have instructions on what each component of what you are deploying is doing.
