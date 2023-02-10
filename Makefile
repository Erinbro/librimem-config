deploy_librimem_infrastructure:
	terraform init

librimem_infrastructure_destroy:
	terraform plan -destroy