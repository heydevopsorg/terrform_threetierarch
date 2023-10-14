#!/bin/bash
export AWS_PAGER=""
aws ecr delete-repository \
    --repository-name ha-app-application-tier \
    --force

aws ecr delete-repository \
    --repository-name ha-app-presentation-tier \
    --force