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
          nrql(query: "FROM Metric SELECT count(aws.ecs.ServiceName) AS `numEcsServices` SINCE 1 week ago") {
            results
          }
        }
      }
    }
    ''')
  
  return queryTemplate.substitute(
    accountId=NEWRELIC_ACCOUNT_ID,
  )

# Check if the account has any ECS services reporting
def doesAccountHaveEcsServices(
    globalVariables,
  ):
  print('Checking ECS service ingest...')

  # Prepare GraphQL query
  query = prepareGraphQlQuery(globalVariables[parser.NEWRELIC_ACCOUNT_ID])

  # Execute GraphQL request
  try:
    response = graphql.executeGraphQlQuery(
      globalVariables[parser.NEWRELIC_API_KEY],
      globalVariables[parser.NEWRELIC_GRAPHQL_ENDPOINT],
      query,
    )

    numEcsServices = response['data']['actor']['account']['nrql']['results'][0]['numEcsServices']
    if numEcsServices == 0:
      print('The account [{}] has no ECS service.'.format(globalVariables[parser.NEWRELIC_ACCOUNT_ID]))
      return False
    else:
      print('The account [{}] has ECS service!'.format(globalVariables[parser.NEWRELIC_ACCOUNT_ID]))
      return True
  except:
    print('Fetching ECS services has failed!')
    return False

# Trigger workflows for ECS Terraform deployment
def triggerEcsWorkflow(
    globalVariables,
  ):

  # Run the ECS workflow only if the account has any ECS services
  if doesAccountHaveEcsServices(globalVariables):
    print('Triggering ECS workflow...')

    payload = {
      'event_type': 'aws_ecs',
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
      print('The ECS workflow is successfully triggered for the account [{}].'.format(globalVariables[parser.NEWRELIC_ACCOUNT_ID]))
    except:
      print('The ECS workflow is failed to be triggered for the account [{}].'.format(globalVariables[parser.NEWRELIC_ACCOUNT_ID]))
