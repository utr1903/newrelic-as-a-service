#################
### Variables ###
#################

### General ###

# New Relic Account ID
variable "NEW_RELIC_ACCOUNT_ID" {
  type = string
}

# New Relic API Key
variable "NEW_RELIC_API_KEY" {
  type = string
}

# New Relic Region
variable "NEW_RELIC_REGION" {
  type = string
}

# Application relationship map
variable "app_relation_map" {
  type = list(object({
    app_name = string,
    related_apps = list(object({
      account_id = number,
      app_names  = string,
    }))
  }))

  default = []
}
######
