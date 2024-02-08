# setup-private-azure-devops-build-agents-using-azure-container-instance-and-terraform


docker build . -t lortcslogcorner.azurecr.io/dockeragent:1.0.1 

az acr login --name  lortcslogcorner

docker push lortcslogcorner.azurecr.io/dockeragent 