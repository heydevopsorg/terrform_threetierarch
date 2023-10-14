 #!/bin/bash
export AWS_PAGER=""
ACCOUNT_ID=$(aws sts get-caller-identity | jq -r .Account)
REGION=us-east-1

# login to ECR
echo "################### Login To ECR ###################"
aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com

# creating ecr repositories
ECR_APPLICATION_REPO_NAME=ha-app-application-tier
aws ecr describe-repositories --repository-names ${ECR_APPLICATION_REPO_NAME} || aws ecr create-repository --repository-name ${ECR_APPLICATION_REPO_NAME}

ECR_PRESENTATION_REPO_NAME=ha-app-presentation-tier
aws ecr describe-repositories --repository-names ${ECR_PRESENTATION_REPO_NAME} || aws ecr create-repository --repository-name ${ECR_PRESENTATION_REPO_NAME}

# building and pushing the application tier image
cd ./application-tier/
echo "################### Building application tier image ###################"
ECR_APPLICATION_TIER_REPO=$(aws ecr describe-repositories --repository-names ${ECR_APPLICATION_REPO_NAME} | jq -r '.repositories[0].repositoryUri')
docker build -t ha-app-application-tier .
docker tag ha-app-application-tier:latest $ECR_APPLICATION_TIER_REPO:latest

echo "################### Pushing application tier image ###################"
docker push $ECR_APPLICATION_TIER_REPO:latest

#building and pushing the presentation tier image
cd ../presentation-tier/
echo "################### Building presentation tier image ###################"
ECR_PRESENTATION_TIER_REPO=$(aws ecr describe-repositories --repository-names ${ECR_PRESENTATION_REPO_NAME} | jq -r '.repositories[0].repositoryUri')
docker build -t ha-app-presentation-tier .
docker tag ha-app-presentation-tier:latest $ECR_PRESENTATION_TIER_REPO:latest

echo "################### Pushing presentation tier image ###################"
docker push $ECR_PRESENTATION_TIER_REPO:latest