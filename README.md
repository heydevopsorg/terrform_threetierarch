HandsOn Demo
1) Clone the code - https://github.com/heydevopsorg/terrform_threetierarch.git
2) Create the AWS account - https://aws.amazon.com/console/
3) Install Docker and terraform on windows
https://docs.docker.com/desktop/install/windows-install/
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
4) Execute the linux command to give permission
chmod +x setup-ecrs.sh
5) Run this on terminal to create the ECR repo and to create images in local
and send those to ECR- ./setup-ecrs.sh
6) Go to terraform folder -
terraform init
terraform plan
terraform apply
