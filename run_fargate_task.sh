#!/bin/bash

STACK_NAME=$1
REGION=$2
SUBNETS=$3

CLUSTER_NAME=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION --query 'Stacks[0].Outputs[?OutputKey==`ClusterName`].OutputValue' --out text)
TASK_DEFINITION=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION --query 'Stacks[0].Outputs[?OutputKey==`TaskDefinitionName`].OutputValue' --out text)
NETWORK_CONF="awsvpcConfiguration={subnets=[$SUBNETS],assignPublicIp='ENABLED'}"


run_new_task(){
	local TASK_ARN=$(aws ecs run-task --cluster $CLUSTER_NAME --task-definition $TASK_DEFINITION  --count 1 --network-configuration $NETWORK_CONF --launch-type FARGATE --region $REGION --query 'tasks[0].taskArn' --out text)
	echo "$TASK_ARN"
}

get_return_Code () {
	local RETURN_CODE=$(aws ecs describe-tasks --tasks $TASK_ARN --cluster $CLUSTER_NAME --region $REGION --query 'tasks[0].containers[0].exitCode' --out text)
	echo "$RETURN_CODE"
}

echo "Running a new Fragate Task task"
TASK_ARN=$(run_new_task)

echo "Waiting until the container finishes running the script"
sleep 60

echo "Checking the Return Code of the job"
RETURN_CODE=$(get_return_Code)
echo "Return Code: $RETURN_CODE \n"

echo "Checking the logs of the job"