from string import Template
import json

import commons.parser as parser
import commons.graphql as graphql
import commons.github as github
import application.apm_related_apps as apm_related_apps

# Prepare GraphQL query
def prepareGraphQlQuery(
    NEWRELIC_ACCOUNT_ID,
  ):
  queryTemplate = Template('''
    {
      actor {
        account(id: $accountId) {
          nrql(query: "FROM Transaction SELECT count(*) AS `numTransactions` SINCE 1 week ago") {
            results
          }
        }
      }
    }
    ''')

  return queryTemplate.substitute(
    accountId=NEWRELIC_ACCOUNT_ID,
  )

# Check if the account has any APMs reporting
def doesAccountHaveApm(
    globalVariables,
  ):
  print('Checking APM ingest...')

  # Prepare GraphQL query
  query = prepareGraphQlQuery(globalVariables[parser.NEWRELIC_ACCOUNT_ID])

  # Execute GraphQL request
  try:
    response = graphql.executeGraphQlQuery(
      globalVariables[parser.NEWRELIC_API_KEY],
      globalVariables[parser.NEWRELIC_GRAPHQL_ENDPOINT],
      query,
    )

    numTransactions = response['data']['actor']['account']['nrql']['results'][0]['numTransactions']
    if numTransactions == 0:
      print('The account [{}] has no APM.'.format(globalVariables[parser.NEWRELIC_ACCOUNT_ID]))
      return False
    else:
      print('The account [{}] has APM!'.format(globalVariables[parser.NEWRELIC_ACCOUNT_ID]))
      return True
  except:
    print('Fetching APM transactions has failed!')
    return False

# Trigger workflows for APM Terraform deployment
def triggerApmWorkflow(
    globalVariables,
  ):

  # Run the APM workflow only if the account has any APM apps
  if doesAccountHaveApm(globalVariables):

    # Fetch individually to be monitored apps
    taggedToRelatedAppsMap = apm_related_apps.fetchIndividuallyToBeMonitoredTaggedAppsMap(globalVariables)

    print('Triggering APM workflow...')

    payload = {
      'event_type': 'apm',
      'client_payload': {
        'newrelic_account_id': globalVariables[parser.NEWRELIC_ACCOUNT_ID],
        'newrelic_api_key': globalVariables[parser.NEWRELIC_API_KEY],
        'newrelic_region': globalVariables[parser.NEWRELIC_REGION],
        'app_relation_map': json.dumps(taggedToRelatedAppsMap),
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
      print('The apm workflow is successfully triggered for the account [{}].'.format(globalVariables[parser.NEWRELIC_ACCOUNT_ID]))
    except:
      print('The apm workflow is failed to be triggered for the account [{}].'.format(globalVariables[parser.NEWRELIC_ACCOUNT_ID]))
