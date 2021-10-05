# # #* Makefile for k8s development.

#! How to ==>
#? Add makefile in the same folder as Dockerfile and git folder (usually repo root folder).
#? Update the CLUSTER_NAME value in CLUSTER_NAME. If not, a k3d cluster with name "gitops-workflow" will be created.
#? Choose your deployment method by choosing a target, for example "make terraform"
##### Colours #############################################
GREEN := $(shell echo -e '\033[0;32m')
NC := $(shell echo -e '\033[0m')
##### Colours #############################################
REPO := $(shell git rev-parse --show-toplevel)
#! How to <==


#? Cluster Parameters
# The name of the local cluster
CLUSTER_NAME := gitops-workflow


#* Targets
#? Deploy with terraform  ==> make terraform
terraform: code_lint \
cluster_create \
tf_apply

#? Deploy with flux  ==> make flux
flux: code_lint \
cluster_create \
flux_deploy

#################################
###* Development
#################################  
#? Lint code  ==> make code_lint
code_lint:
	@echo "$(GREEN) ==> Github Super-Linter will validate your source code.$(NC) < https://github.com/github/super-linter >"
	docker run --rm -e KUBERNETES_KUBEVAL_OPTIONS=--ignore-missing-schemas -e RUN_LOCAL=true \
	-v $(REPO):/tmp/lint ghcr.io/github/super-linter:slim-v4

ifeq ($(shell uname), Linux)
	find $(REPO) -type f -name "super-linter.log" -exec rm -f {} \;
else
	powershell "Get-ChildItem -Recurse $(REPO) | where Name -match 'super-linter.log' | Remove-Item"
endif

#? Create local cluster  ==> make cluster_create
cluster_create:
	CLUSTER_NAME=$(CLUSTER_NAME) ./scripts/k3d_cluster.sh 
  
tf_apply:
	terraform -chdir=terraform init
	terraform -chdir=terraform apply --auto-approve
	@echo "$(GREEN) ==> Access Openfaas web ui in:$(NC) http://localhost:8080"
	kubectl port-forward -n openfaas svc/gateway 8080:8080 &

#? Deploy with flux  ==> make flux_deploy
flux_deploy:
	terraform -chdir=fluxV2 init
	terraform -chdir=fluxV2 apply --auto-approve
	@echo "$(GREEN) ==> Access Openfaas web ui in:$(NC) http://localhost:8080"
	kubectl port-forward -n openfaas svc/gateway 8080:8080 &	

clean:	
	k3d cluster delete $(CLUSTER_NAME)
	
	