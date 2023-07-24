from string import Template

import commons.parser as parser
import commons.graphql as graphql

# Prepare GraphQL query individual applications
def prepareGraphQlQueryForTaggedApps(
    NEWRELIC_ACCOUNT_ID,
  ):
  queryTemplate = Template('''
    {
      actor {
        entitySearch(queryBuilder: {tags: [{key: "instrumentation.provider", value: "newRelic"},{key: "accountId", value: "$accountId"},{key: "naas.monitor.me", value: "true"}]}) {
          results {
            entities {
              domain
              entityType
              name
              guid
            }
          }
        }
      }
    }
    ''')
  
  return queryTemplate.substitute(
    accountId=NEWRELIC_ACCOUNT_ID,
  )

# Fetch to be monitored tagged apps
def fetchTaggedApps(
    globalVariables,
  ):

  # Prepare GraphQL query
  query = prepareGraphQlQueryForTaggedApps(globalVariables[parser.NEWRELIC_ACCOUNT_ID])

  # Execute GraphQL request
  try:
    response = graphql.executeGraphQlQuery(
      globalVariables[parser.NEWRELIC_API_KEY],
      globalVariables[parser.NEWRELIC_GRAPHQL_ENDPOINT],
      query,
    )

    taggedApps = response['data']['actor']['entitySearch']['results']['entities']
    print(taggedApps)

    if len(taggedApps) == 0:
      print('The account [{}] has no specificly tagged application to monitor.'.format(globalVariables[parser.NEWRELIC_ACCOUNT_ID]))
    else:
      print('The account [{}] has specificly tagged application to monitor!'.format(globalVariables[parser.NEWRELIC_ACCOUNT_ID]))
    return taggedApps
  except:
    print('Fetching tagged applications to monitor has failed!')
    raise Exception()

# Prepare GraphQL query for related outbound applications
def prepareGraphQlQueryForRelatedOutboundApps(
    entityGuid,
  ):
  queryTemplate = Template('''
    {
      actor {
        entity(guid: "$entityGuid") {
          relatedEntities(filter: {relationshipTypes: {include: CALLS}, direction: OUTBOUND}) {
            results {
              target {
                entity {
                  name
                  domain
                  entityType
                  guid
                  accountId
                }
              }
            }
          }
        }
      }
    }
    ''')
  
  return queryTemplate.substitute(
    entityGuid=entityGuid,
  )

# Prepare GraphQL query for related inbound applications
def prepareGraphQlQueryForRelatedInboundApps(
    entityGuid,
  ):
  queryTemplate = Template('''
    {
      actor {
        entity(guid: "$entityGuid") {
          relatedEntities(filter: {relationshipTypes: {include: CALLS}, direction: INBOUND}) {
            results {
              source {
                entity {
                  name
                  domain
                  entityType
                  guid
                  accountId
                }
              }
            }
          }
        }
      }
    }
    ''')
  
  return queryTemplate.substitute(
    entityGuid=entityGuid,
  )


# Fetch related applications which tagged application is calling - OUTBOUND
def fetchRelatedOutboundAppsOfTaggedApp(
    globalVariables,
    taggedApp,
  ):

  # Prepare GraphQL query
  query = prepareGraphQlQueryForRelatedOutboundApps(taggedApp['guid'])

  # Execute GraphQL request
  try:
    response = graphql.executeGraphQlQuery(
      globalVariables[parser.NEWRELIC_API_KEY],
      globalVariables[parser.NEWRELIC_GRAPHQL_ENDPOINT],
      query,
    )

    relatedEntities = response['data']['actor']['entity']['relatedEntities']['results']

    # Filter the APM applications
    relatedApps = []
    for relatedEntity in relatedEntities:
      if relatedEntity['target']['entity']['domain'] == "APM":
        relatedApps.append(relatedEntity)

    if len(relatedApps) == 0:
      print('The app [{}] has no related outbound applications.'.format(taggedApp['name']))
    else:
      print('The app [{}] has related outbound applications!'.format(taggedApp['name']))
    return relatedApps
  except:
    print('Fetching related outbound applications to monitor has failed!')
    raise Exception()

# Fetch related applications which are calling tagged application is calling - INBOUND
def fetchRelatedInboundAppsOfTaggedApp(
    globalVariables,
    taggedApp,
  ):

  # Prepare GraphQL query
  query = prepareGraphQlQueryForRelatedInboundApps(taggedApp['guid'])

  # Execute GraphQL request
  try:
    response = graphql.executeGraphQlQuery(
      globalVariables[parser.NEWRELIC_API_KEY],
      globalVariables[parser.NEWRELIC_GRAPHQL_ENDPOINT],
      query,
    )

    relatedEntities = response['data']['actor']['entity']['relatedEntities']['results']

    # Filter the APM applications
    relatedApps = []
    for relatedEntity in relatedEntities:
      if relatedEntity['source']['entity']['domain'] == "APM":
        relatedApps.append(relatedEntity)

    if len(relatedApps) == 0:
      print('The app [{}] has no related inbound applications.'.format(taggedApp['name']))
    else:
      print('The app [{}] has related inbound applications!'.format(taggedApp['name']))
    return relatedApps
  except:
    print('Fetching related inbound applications to monitor has failed!')
    raise Exception()

# Add the related app information to the map
def addRelatedAppToMap(
    relatedAppsMap,
    relatedAppAccountId,
    relatedAppName,
  ):
  if relatedAppAccountId in relatedAppsMap:
    relatedAppsMap[relatedAppAccountId].add(relatedAppName)
  else:
    relatedAppsMap[relatedAppAccountId] = set([relatedAppName])


# Fetch related applications of the tagged application
def createTaggedToRelatedAppsMap(
    globalVariables,
    taggedApps,
  ):

  relatedAppsMap = dict()

  # Loop over all tagged apps
  for taggedApp in taggedApps:

    relatedAppsMapOfTaggedApp = dict()

    # Fetch related outbound applications of the tagged application
    relatedOutboundApps = fetchRelatedOutboundAppsOfTaggedApp(globalVariables, taggedApp)
  
    # Add outbound related app names
    if len(relatedOutboundApps) != 0:
      for relatedApp in relatedOutboundApps:
        relatedAppAccountId = relatedApp['target']['entity']['accountId']
        relatedAppName = relatedApp['target']['entity']['name']
        addRelatedAppToMap(relatedAppsMapOfTaggedApp, relatedAppAccountId, relatedAppName)

    # Fetch related inbound applications of the tagged application
    relatedInboundApps = fetchRelatedInboundAppsOfTaggedApp(globalVariables, taggedApp)

    # Add inbound related app names
    if len(relatedInboundApps) != 0:
      for relatedApp in relatedInboundApps:
        relatedAppAccountId = relatedApp['source']['entity']['accountId']
        relatedAppName = relatedApp['source']['entity']['name']
        addRelatedAppToMap(relatedAppsMapOfTaggedApp, relatedAppAccountId, relatedAppName)

    if len(relatedAppsMapOfTaggedApp) != 0:
      relatedAppsMap[taggedApp['name']] = relatedAppsMapOfTaggedApp

  return relatedAppsMap

def formatTaggedToRelatedAppsMap(
    taggedToRelatedAppsMap,
  ):

  formattedMap = []
  for taggedAppName, relatedApps in taggedToRelatedAppsMap.items():
    relatedAppsFormatted = []
    for relatedAppAccountId, relatedAppNames in relatedApps.items():
      relatedAppsFormatted.append({
        'account_id': relatedAppAccountId,
        'app_names': ','.join(list(relatedAppNames)),
      })
    formattedMap.append({
      'app_name': taggedAppName,
      'related_apps': relatedAppsFormatted,
    })

  return formattedMap

# Fetch individually to be monitored tagged apps
def fetchIndividuallyToBeMonitoredTaggedAppsMap(
    globalVariables,
  ):

  # Fetch to be monitored tagged apps
  taggedApps = fetchTaggedApps(globalVariables)

  # Fetch related apps of tagged app
  taggedToRelatedAppsMap = createTaggedToRelatedAppsMap(globalVariables, taggedApps)

  # Format the map according to Terraform input
  taggedToRelatedAppsMapFormatted = formatTaggedToRelatedAppsMap(taggedToRelatedAppsMap)
  
  return taggedToRelatedAppsMapFormatted
