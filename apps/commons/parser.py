import os

GITHUB_REPO_PAT='GITHUB_REPO_PAT'
GITHUB_WORKFLOW_URL='GITHUB_WORKFLOW_URL'
NEWRELIC_ACCOUNT_ID='NEWRELIC_ACCOUNT_ID'
NEWRELIC_API_KEY='NEWRELIC_API_KEY'
NEWRELIC_REGION='NEWRELIC_REGION'
NEWRELIC_GRAPHQL_ENDPOINT='NEWRELIC_GRAPHQL_ENDPOINT'

# Get New Relic API key and region from the environment variables
def parseEnvironmentVariables():
  global GITHUB_REPO_PAT
  global GITHUB_WORKFLOW_URL
  global NEWRELIC_ACCOUNT_ID
  global NEWRELIC_API_KEY
  global NEWRELIC_REGION
  global NEWRELIC_GRAPHQL_ENDPOINT

  globalVariables = dict()

  # Github repo PAT
  githubRepoPat = os.getenv(GITHUB_REPO_PAT)
  if githubRepoPat == None:
    print('Github repo PAT is not given!')
    exit(1)
  else:
    globalVariables[GITHUB_REPO_PAT] = githubRepoPat

  # Github workflow URL
  githubWorkflowUrl = os.getenv(GITHUB_WORKFLOW_URL)
  if githubWorkflowUrl == None:
    print('Github workflow URL is not given!')
    exit(1)
  else:
    globalVariables[GITHUB_WORKFLOW_URL] = githubWorkflowUrl

  # New Relic account ID
  newrelicAccountId = os.getenv(NEWRELIC_ACCOUNT_ID)
  if newrelicAccountId == None:
    print('New Relic API account ID is not given!')
    exit(1)
  else:
    globalVariables[NEWRELIC_ACCOUNT_ID] = newrelicAccountId

  # New Relic API key
  newrelicApiKey = os.getenv(NEWRELIC_API_KEY)
  if NEWRELIC_API_KEY == None:
    print('New Relic API Key is not given!')
    exit(1)
  else:
    globalVariables[NEWRELIC_API_KEY] = newrelicApiKey

  # New Relic region
  newrelicRegion = os.getenv(NEWRELIC_REGION)
  if NEWRELIC_REGION == None:
    print('New Relic region is not given!')
    exit(1)
  else:
    globalVariables[NEWRELIC_REGION] = newrelicRegion

  # New Relic GraphQL endpoint
  if newrelicRegion == 'eu':
    globalVariables[NEWRELIC_GRAPHQL_ENDPOINT] = 'https://api.eu.newrelic.com/graphql'
  else:
    globalVariables[NEWRELIC_GRAPHQL_ENDPOINT] = 'https://api.newrelic.com/graphql'

  return globalVariables
