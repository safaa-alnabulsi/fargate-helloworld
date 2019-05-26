# Fargate Hello-World!

In this basic example, you will get a running Fargate task in two steps:

## 1. Setup the AWS Infrastructure

This includes: ECR, ECS cluster, Task definition and required roles.

First, get AWS Account credentials and then run the following the script:

	 ./deploy.sh CLUSER_STACK_NAME ECR_REPO_NAME IMAGE_NAME IMAGE_TAG REGION ACCOUNT_ID


## 2. Running a new Fargate Task

Run the following script to run a new task:

	./run_new_task.sh CLUSER_STACK_NAME REGION SUBNETS

### Ready to Run example

	./deploy.sh 'hello-fragate-stack' 'hello-fargate-ecr-repo' 'hello-image' '1' 'eu-central-1' '111111111'
    ./run_new_task.sh 'hello-fragate-stack' 'eu-central-1' 'subnet1,2,3'