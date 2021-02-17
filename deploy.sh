#!/bin/sh

JQ="jq --raw-output --exit-status"

configure_aws_cli() {
  aws --version
  aws configure set default.region us-east-1
  aws configure set default.output json
  echo "AWS Configured!"
}

register_definition() {
  if revision=$(aws ecs register-task-definition --cli-input-json "$task_def" | $JQ '.taskDefinition.taskDefinitionArn'); then
    echo "Revision: $revision"
  else
    echo "Failed to register task definition"
    return 1
  fi
}

# new
update_service() {
  if [[ $(aws ecs update-service --cluster $cluster --service $service --task-definition $revision | $JQ '.service.taskDefinition') != $revision ]]; then
    echo "Error updating service."
    return 1
  fi
}

deploy_cluster() {

  cluster="micro-react-nginx-cluster" # for all commits on git this will update the ecs
  
  service="micro-react-nginx-users-service"  # for all commits on git this will update the ecs

#$AWS_ACCOUNT_ID
  # Users
  template="ecs_users_taskdefinition.json"
  task_template=$(cat "ecs/$template")
  task_def=$(printf "$task_template" $DOCKER_USERNAME $DATABASE_HOST $MYSQL_ROOT_PASSWORD $MYSQL_USER)
  echo "$task_def"
  register_definition
  update_service  # for all commits on git this will update the ecs

  # Client
  service="micro-react-nginx-client-service"   # for all commits on git this will update the ecs
  template="ecs_client_taskdefinition.json"
  task_template=$(cat "ecs/$template")
  task_def=$(printf "$task_template" $DOCKER_USERNAME)
  echo "$task_def"
  register_definition
  update_service   # for all commits on git this will update the ecs

}
#OLD------------ master
# configure_aws_cli
# deploy_cluster
# --------
# new
echo $CODEBUILD_WEBHOOK_BASE_REF
echo $CODEBUILD_WEBHOOK_HEAD_REF
echo $CODEBUILD_WEBHOOK_TRIGGER
echo $CODEBUILD_WEBHOOK_EVENT

# new
if  [ "$CODEBUILD_WEBHOOK_TRIGGER" == "branch/main" ] && \
    [ "$CODEBUILD_WEBHOOK_HEAD_REF" == "refs/heads/main" ]
then
  echo "Updating ECS."
  configure_aws_cli
  deploy_cluster
fi