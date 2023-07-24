from string import Template

import commons.parser as parser
import commons.graphql as graphql
import commons.github as github

# Prepare GraphQL query
def prepareGraphQlQuery(
    NEWRELIC_ACCOUNT_ID,
  ):
  queryTemplate = Template('''
    {
      actor {
        account(id: $accountId) {
          nrql(query: "FROM SystemSample SELECT count(hostname) AS `numHosts` SINCE 1 week ago") {
            results
          }
        }
      }
    }
    ''')
  
  return queryTemplate.substitute(
    accountId=NEWRELIC_ACCOUNT_ID,
  )

# Check if the account has any hosts reporting
def doesAccountHaveHosts(
    globalVariables,
  ):
  print('Checking host ingest...')

  # Prepare GraphQL query
  query = prepareGraphQlQuery(globalVariables[parser.NEWRELIC_ACCOUNT_ID])

  # Execute GraphQL request
  try:
    response = graphql.executeGraphQlQuery(
      globalVariables[parser.NEWRELIC_API_KEY],
      globalVariables[parser.NEWRELIC_GRAPHQL_ENDPOINT],
      query,
    )

    numHosts = response['data']['actor']['account']['nrql']['results'][0]['numHosts']
    if numHosts == 0:
      print('The account [{}] has no hosts.'.format(globalVariables[parser.NEWRELIC_ACCOUNT_ID]))
      return False
    else:
      print('The account [{}] has hosts!'.format(globalVariables[parser.NEWRELIC_ACCOUNT_ID]))
      return True
  except:
    print('Fetching hosts has failed!')
    return False

# Trigger workflows for host Terraform deployment
def triggerHostWorkflow(
    globalVariables,
  ):

  # Run the host workflow only if the account has any hosts
  if doesAccountHaveHosts(globalVariables):
    print('Triggering host workflow...')

    payload = {
      'event_type': 'host',
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
      print('The host workflow is successfully triggered for the account [{}].'.format(globalVariables[parser.NEWRELIC_ACCOUNT_ID]))
    except:
      print('The host workflow is failed to be triggered for the account [{}].'.format(globalVariables[parser.NEWRELIC_ACCOUNT_ID]))
