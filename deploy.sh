#!/bin/bash

STACK_NAME=$1
ECR_REPO_NAME=$2
IMAGE_NAME=$3
IMAGE_TAG=$4
REGION=$5
ACCOUNT_ID=$6

create_ecr () {
    aws ecr create-repository --repository-name $ECR_REPO_NAME --region $REGION
}

 #	aws cloudformation deploy --stack-name $STACK_NAME-ecr --template-file templates/ecr.yaml \
#	--parameter-overrides RepositoryName=$ECR_REPO_NAME --region $REGION

build_and_push_docker () {
	$(aws ecr get-login --no-include-email --region $REGION)
	docker build -f Dockerfile -t $IMAGE_NAME .
	docker tag $IMAGE_NAME:latest $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$ECR_REPO_NAME:$IMAGE_TAG
	docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$ECR_REPO_NAME:$IMAGE_TAG
}

deploy_stack(){
	aws cloudformation deploy --stack-name $STACK_NAME --template-file templates/ecs-fargate.yaml \
	--parameter-overrides ImageName=$IMAGE_NAME ImageTag=$IMAGE_TAG \
	--region $REGION --capabilities CAPABILITY_NAMED_IAM CAPABILITY_IAM
}

echo "Creating a new ECR"
create_ecr

echo "Building the new docker image, tagging it and pushing it to ECR"
build_and_push_docker

echo "Deploying the ECS cluster, Roles and Task Definition"
deploy_stack