# setup-private-azure-devops-build-agents-using-azure-container-instance-and-terraform

$subscriptionName="Visual Studio Enterprise"
az account set --subscription  $subscriptionName

# create resource group
$resourceGroupName="rg-datasynchro-iac"
$resourceGroupLocation="westeurope"
$storageAccountName ="stdatasynchroiac"
# create resource group
./powershell/resourceGroup.ps1 -resourceGroupName $resourceGroupName `
                               -resourceGroupLocation $resourceGroupLocation

# create terraform backend storage account
./powershell/storageAccount.ps1 -resourceGroupName $resourceGroupName `
                                -resourceGroupLocation $resourceGroupLocation  ` -storageAccountName $storageAccountName

# create azure container registry
$subscriptionName="Visual Studio Enterprise"
az account set --subscription  $subscriptionName
terraform init -var-file="dev.tfvars"
terraform plan -target="module.container_registry" -var-file="dev.tfvars" 
terraform apply -target="module.container_registry" -var-file="dev.tfvars" --auto-approve

#  docker build and push
$registryName="lortcslogcorner"
$tag="1.0.2"
$imageName="dockeragent"
az acr login --name  $registryName

docker build . -t "${registryName}.azurecr.io/${imageName}:${tag}"

docker push "${registryName}.azurecr.io/${imageName}:${tag}" 

# deploy container instance
$devopsOrg="https://dev.azure.com/logcornerworkshop"
$personalAccessToken="{{REPLACE_WITH_YOUR_PERSONAL_ACCESS_TOKEN}}"
$poolName="{{REPLACE_WITH_YOUR_POOL_NAME}}"  // "DOCKER-AGENTS"

terraform init -var-file="dev.tfvars"

terraform plan -target="module.container_instance" -var-file="dev.tfvars" -var "build_number=$tag" -var "AZP_TOKEN=$personalAccessToken" -var "AZP_URL=$devopsOrg"   -var "AZP_POOL=$poolName"

terraform apply -target="module.container_instance" -var-file="dev.tfvars" -var "build_number=$tag" -var "AZP_TOKEN=$personalAccessToken" -var "AZP_URL=$devopsOrg"  -var "AZP_POOL=$poolName" --auto-approve

$resourceGroupName="rg-datasynchro-iac"
$containerName="devops-container"
az container logs --resource-group $resourceGroupName --name $containerName
az container attach --resource-group $resourceGroupName --name $containerName
az container show --resource-group $resourceGroupName --name $containerName
