# sudo pip3 install requests

import requests

# Execute GraphQL query
def executeGraphQlQuery(
    NEWRELIC_API_KEY,
    NEWRELIC_GRAPHQL_ENDPOINT,
    query,
  ):
  print('Executing GraphQL query...')

  # Set headers
  headers = {
    'Api-Key': NEWRELIC_API_KEY,
    'Content-Type': 'application/json',
  }

  # Execute HTTP request
  response = requests.post(
    NEWRELIC_GRAPHQL_ENDPOINT,
    json={'query': query},
    headers=headers
  )

  if response.status_code != 200:
    print('GraphQL query has failed. Status code: {} | Response: {}.'.format(response.status_code, response.json()))
    raise Exception()

  return response.json()
