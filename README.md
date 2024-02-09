# setup-private-azure-devops-build-agents-using-azure-container-instance-and-terraform

docker build . -t lortcslogcorner.azurecr.io/dockeragent:1.0.1 

az acr login --name  lortcslogcorner

docker push lortcslogcorner.azurecr.io/dockeragent 

terraform apply -var-file="dev.tfvars"  --auto-approve

terraform plan  -var-file="dev.tfvars" -var "build_number=1.0.0" -var "AZP_TOKEN=hgmscqc65n7pwp6d3uj5dkxesqigxlqguyp6pouiq7gtctzlwiya" -var "AZP_URL=https://dev.azure.com/logcornerworkshop"

terraform apply -target="module.container_registry" -var-file="dev.tfvars" -var "build_number=1.0.0" -var "AZP_TOKEN=xxxxxxxxxxxxxxxxxxxx" -var "AZP_URL=https://dev.azure.com/logcornerworkshop"   --auto-approve


terraform apply -target="module.container_instance" -var-file="dev.tfvars" -var "build_number=1.0.0" -var "AZP_TOKEN=xxxxxxxxxxxxx" -var "AZP_URL=https://dev.azure.com/logcornerworkshop"   --auto-approve