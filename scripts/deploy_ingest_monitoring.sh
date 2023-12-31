#!/bin/bash

## How to use the script from the command line
# NEWRELIC_ACCOUNT_ID=NEWRELIC_ACCOUNT_ID NEWRELIC_REGION="NEWRELIC_REGION" NEWRELIC_API_KEY="NEWRELIC_API_KEY" bash deploy_application_monitoring.sh --resource-group-name "RESOURCE_GROUP_NAME" --storage-account-name "STORAGE_ACCOUNT_NAME" --blob-container-name "BLOB_CONTAINER_NAME"

# Get commandline arguments
while (( "$#" )); do
  case "$1" in
    --destroy)
      flagDestroy="true"
      shift
      ;;
    --dry-run)
      flagDryRun="true"
      shift
      ;;
    --resource-group-name)
      resourceGroupName="$2"
      shift
      ;;
    --storage-account-name)
      storageAccountName="$2"
      shift
      ;;
    --blob-container-name)
      blobContainerName="$2"
      shift
      ;;
    *)
      shift
      ;;
  esac
done

### Check input

# Azure resource group name
if [[ $resourceGroupName == "" ]]; then
  echo "Define the Azure resource group name! (--resource-group-name)"
  exit 1
fi

# Azure storage account name
if [[ $storageAccountName == "" ]]; then
  echo "Define the Azure storage account name! (--storage-account-name)"
  exit 1
fi

# Azure blob container name
if [[ $blobContainerName == "" ]]; then
  echo "Define the Azure blob container name! (--blob-container-name)"
  exit 1
fi

# New Relic account ID
if [[ $NEWRELIC_ACCOUNT_ID == "" ]]; then
  echo "Define New Relic account ID as an environment variable [NEWRELIC_ACCOUNT_ID]. For example: -> export NEWRELIC_ACCOUNT_ID=xxx"
  exit 1
fi

# New Relic region
if [[ $NEWRELIC_REGION == "" ]]; then
  echo "Define New Relic region as an environment variable [NEWRELIC_REGION]. For example: -> export NEWRELIC_REGION=us or export NEWRELIC_REGION=eu"
  exit 1
else
  if [[ $NEWRELIC_REGION != "us" && $NEWRELIC_REGION != "eu" ]]; then
    echo "New Relic region can either be 'us' or 'eu'."
    exit 1
  fi
fi

# New Relic API key
if [[ $NEWRELIC_API_KEY == "" ]]; then
  echo "Define New Relic API key as an environment variable [NEWRELIC_API_KEY]. For example: -> export NEWRELIC_API_KEY=xxx"
  exit 1
fi

#################
### TERRAFORM ###
#################

if [[ $flagDestroy != "true" ]]; then

  # Initialize Terraform
  terraform -chdir=../terraform/ingest init \
    -upgrade \
    -backend-config="resource_group_name=$resourceGroupName" \
    -backend-config="storage_account_name=$storageAccountName" \
    -backend-config="container_name=$blobContainerName" \
    -backend-config="key=${NEWRELIC_ACCOUNT_ID}-ingest-local"

  # Plan Terraform
  terraform -chdir=../terraform/ingest plan \
    -var NEW_RELIC_ACCOUNT_ID=$NEWRELIC_ACCOUNT_ID \
    -var NEW_RELIC_API_KEY=$NEWRELIC_API_KEY \
    -var NEW_RELIC_REGION=$NEWRELIC_REGION \
    -out "./tfplan"

  # Apply Terraform
  if [[ $flagDryRun != "true" ]]; then
    terraform -chdir=../terraform/ingest apply tfplan
  fi
else

  # Destroy Terraform
  terraform -chdir=../terraform/ingest destroy \
    -var NEW_RELIC_ACCOUNT_ID=$NEWRELIC_ACCOUNT_ID \
    -var NEW_RELIC_API_KEY=$NEWRELIC_API_KEY \
    -var NEW_RELIC_REGION=$NEWRELIC_REGION
fi
#########
