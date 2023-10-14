#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
aws ecr get-login-password --region ${region}  | docker login --username AWS --password-stdin ${ecr_url}
docker run --restart always -e APPLICATION_LOAD_BALANCER=${application_load_balancer} -p 3000:3000 -d ${ecr_url}/${ecr_repo_name}:latest