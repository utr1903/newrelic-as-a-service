#!/bin/bash

### Set parameters
program="naas"
locationLong="westeurope"
locationShort="euw"
project="terraform"

servicePrincipalName="naas-terraform"

### Set variables
resourceGroupName="rg${program}${locationShort}${project}"
storageAccountName="st${program}${locationShort}${project}"
blobContainerName="tfstates"

# Get subscription ID
subscriptionId=$(az account show \
  2> /dev/null \
  | jq -r .id)
if [[ $subscriptionId == "" ]]; then
  echo -e "Subscription ID could not be retrieved.\n"
  exit 1
fi

# Create resource group
echo "Checking shared resource group [${resourceGroupName}]..."
resourceGroup=$(az group show \
  --name $resourceGroupName \
  2> /dev/null)

if [[ $resourceGroup == "" ]]; then
  echo " -> Shared resource group does not exist. Creating..."

  resourceGroup=$(az group create \
    --name $resourceGroupName \
    --location $locationLong)

  echo -e " -> Shared resource group is created successfully.\n"
else
  echo -e " -> Shared resource group already exists.\n"
fi

# Create storage account
echo "Checking shared storage account [${storageAccountName}]..."
storageAccount=$(az storage account show \
    --resource-group $resourceGroupName \
    --name $storageAccountName \
  2> /dev/null)

if [[ $storageAccount == "" ]]; then
  echo " -> Shared storage account does not exist. Creating..."

  storageAccount=$(az storage account create \
    --resource-group $resourceGroupName \
    --name $storageAccountName \
    --sku "Standard_LRS" \
    --encryption-services "blob")

  echo -e " -> Shared storage account is created successfully.\n"
else
  echo -e " -> Shared storage account already exists.\n"
fi

# Create blob container
echo "Checking Terraform blob container [${blobContainerName}]..."
blobContainer=$(az storage container show \
  --account-name $storageAccountName \
  --name $blobContainerName \
  2> /dev/null)

if [[ $blobContainer == "" ]]; then
  echo " -> Terraform blob container does not exist. Creating..."

  blobContainer=$(az storage container create \
    --account-name $storageAccountName \
    --name $blobContainerName \
    2> /dev/null)

  echo -e " -> Terraform blob container is created successfully.\n"
else
  echo -e " -> Terraform blob container already exists.\n"
fi

# Create service principal for Github workflow
echo "Checking service principal [${servicePrincipalName}]..."
servicePrincipal=$(az ad sp list --display-name $servicePrincipalName \
  | jq -r '.[0]')
if [[ $servicePrincipal == "null" ]]; then
  echo " -> Service principal does not exist. Creating..."
  az ad sp create-for-rbac \
    --name $servicePrincipalName \
    --role "contributor" \
    --scopes "/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Storage/storageAccounts/${storageAccountName}"
  echo -e " -> Service principal is created successfully.\n"
else
  echo -e " -> Service principal already exists.\n"
fi

echo "##############################################################################"
echo "!!! Store the credentials that is prompted to terminal into Github secrets !!!"
echo "##############################################################################"
