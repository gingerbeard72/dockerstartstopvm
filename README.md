# Docker Stop and Start all VM's 
This project has been created off a task that I worked on recently in my job. I have dockerised this project as a way to develop my docker knowledge and learn a few things. This script and the actions that it takes probably doesnt belong in a docker container but it has been a fun project. 

The Powershell script will use an Environment Variable passed into the docker run command to set the specific Azure Resource Group, build a list of VM's in the Resource Group, Stop, wait, then Start all VM's individually. The command will run using a Service Principle in your Azure Subscription. 

This is designed to be used as and when required in a subscription. The image should be built with your tenant ID, Subscription ID and password included in the code (until I find time to make this more secure).

The docker image is built off the Microsoft Azure Powershell (latest) image.

### Pre-requisites
1. You will need to have a Service Principle created in your Subscription.
   https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal
   
   NOTE: Ensure that the SPN has permissions to your Subscription by following this guide
   https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal#assign-a-role-to-the-application

2. Create you certificate for the Service principle and add the Certificate to the SPN in the Azure Portal
   https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-self-signed-certificate

3. You will need to update the following lines of code prior to building the docker image

    $tenantId = "Your Tenanat ID"
    $ApplicationId = "Your SPN ID"
    $securePassword = " Your Password" | ConvertTo-SecureString -AsPlainText -Force
    Connect-AzAccount -Subscription "Your Subscription ID" 

4. Add your PFX file to the directory where your Dockerfile is located so that it can be included in the build


### Build and Run

Execute the build command to create the docker image.
 docker build -t startstopvm . 
 
Execute the run command to recycle all of the VM's in the named resource group. The command needs an environment variable included in the command to overwrite the default resource group name included in the Dockerfile

  docker run -it -e rg=yourresourcegroupname startstopvm
  
  NOTE: This code comes without warranty and you should always run this in a test environment before being used in a Production environment.
