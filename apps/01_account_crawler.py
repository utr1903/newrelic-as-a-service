import commons.parser as parser
import ingest.ingest as ingest
import application.apm as apm
import host.host as host
import aws.aws as aws

# Parse environment variables
def parseEnvironmentVariables():
  return parser.parseEnvironmentVariables()

# Trigger workflows for ingest Terraform deployment
def triggerIngestWorkflow(
    globalVariables
  ):
  ingest.triggerIngestWorkflow(globalVariables)

# Trigger workflows for APM Terraform deployment
def triggerApmWorkflow(
    globalVariables
  ):
  apm.triggerApmWorkflow(globalVariables)

# Trigger workflows for host Terraform deployment
def triggerHostWorkflow(
    globalVariables
  ):
  host.triggerHostWorkflow(globalVariables)

# Trigger workflows for host Terraform deployment
def triggerAwsWorkflows(
    globalVariables
  ):
  aws.triggerAwsWorkflows(globalVariables)

def main():

  # Parse environment variables
  globalVariables = parseEnvironmentVariables()

  # Trigger Terraform workflow for ingest
  triggerIngestWorkflow(globalVariables)

  # Trigger Terraform workflow for APM
  triggerApmWorkflow(globalVariables)

  # Trigger Terraform workflow for host
  triggerHostWorkflow(globalVariables)

  # Trigger Terraform workflows for AWS
  triggerAwsWorkflows(globalVariables)

## Run the following in order to replicate the actual workflow Python step
# GITHUB_WORKFLOW_URL="" GITHUB_REPO_PAT="" NEWRELIC_ACCOUNT_ID="" NEWRELIC_API_KEY="" NEWRELIC_REGION="" NEWRELIC_GRAPHQL_ENDPOINT="" python3 apps/01_account_crawler.py

main()
