import aws.ecs.ecs as ecs

# Trigger workflows for ECS Terraform deployment
def triggerEcsWorkflow(
    globalVariables
  ):
  ecs.triggerEcsWorkflow(globalVariables)

# Trigger all available AWS workflows
def triggerAwsWorkflows(
    globalVariables
  ):
  triggerEcsWorkflow(globalVariables)
