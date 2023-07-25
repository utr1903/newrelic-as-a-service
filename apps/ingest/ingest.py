import commons.parser as parser
import commons.github as github

# Trigger workflows for ingest Terraform deployment
def triggerIngestWorkflow(
    globalVariables,
  ):
  print('Triggering ingest workflow...')

  # Prepare workflow payload
  payload = {
    'event_type': 'ingest',
    'client_payload': {
      'newrelic_account_id': globalVariables[parser.NEWRELIC_ACCOUNT_ID],
      'newrelic_api_key': globalVariables[parser.NEWRELIC_API_KEY],
      'newrelic_region': globalVariables[parser.NEWRELIC_REGION],
      'terraform_destroy': False
    }
  }

  # Trigger Github workflow
  try:
    github.executeGithubWorkflowRequest(
      globalVariables[parser.GITHUB_WORKFLOW_URL],
      globalVariables[parser.GITHUB_REPO_PAT],
      payload,
    )
    print('The ingest workflow is successfully triggered for the account [{}].'.format(globalVariables[parser.NEWRELIC_ACCOUNT_ID]))
  except:
    print('The ingest workflow is failed to be triggered for the account [{}].'.format(globalVariables[parser.NEWRELIC_ACCOUNT_ID]))
