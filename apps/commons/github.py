# sudo pip3 install requests

import requests

# Execute HTTP request to Github workflow
def executeGithubWorkflowRequest(
    GITHUB_WORKFLOW_URL,
    GITHUB_REPO_PAT,
    payload,
  ):

  headers = {
    'Authorization': "Bearer {}".format(GITHUB_REPO_PAT),
    'Content-Type': 'application/json',
    'Accept': 'application/vnd.github+json',
  }

  response = requests.post(
    GITHUB_WORKFLOW_URL,
    json=payload,
    headers=headers,
  )

  if response.status_code == 204:
    print('Triggering Github workflow is successful.')
  else:
    print('Triggering Github workflow is failed. Status code: {} | Response: {}'.format(response.status_code, response.json()))
    raise Exception()
