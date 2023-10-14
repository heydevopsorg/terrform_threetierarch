 #!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${ecr_url}
docker run -p 3000:3000 --restart always -e RDS_HOSTNAME=${rds_hostname} -e RDS_USERNAME=${rds_username} -e RDS_PASSWORD=${rds_password} -e RDS_PORT=${rds_port} -e RDS_DB_NAME=${rds_db_name} -d ${ecr_url}/${ecr_repo_name}:latest