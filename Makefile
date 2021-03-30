include .env

compose=docker-compose
config= --env-file .env
DOCKER_IMAGE=${DOCKER_REGISTRY}/${DOCKER_REPOSITORY}
PHONY: help
help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: d-build
d-build: ## DOCKER Build image using maven build plugin
	docker build --no-cache -t ${DOCKER_IMAGE}:${TAG} .

.PHONY: d-scan
d-scan: ## DOCKER Scan Image
	docker scan  ${DOCKER_IMAGE}:${TAG}

.PHONY: d-run
d-run: ## DOCKER RUN the container detached. Very usefull if you want use it like a CLI 
	docker run -d -it --rm --name ${CONTAINER_NAME} -v ${KUBECONFIG_PATH}:/.kube/ ${DOCKER_IMAGE}:${TAG}

.PHONY: d-run-it
d-run-it: ## DOCKER RUN Interactive. With this mode, you will go into the container at the runtime.
	docker run -it --rm --name ${CONTAINER_NAME} -v ${KUBECONFIG_PATH}:/.kube/ ${DOCKER_IMAGE}:${TAG}

.PHONY: d-push
d-push: ## DOCKER Push 
	docker push  ${DOCKER_IMAGE}:${TAG}
	
.PHONY: d-exec
d-exec: ## DOCKER EXEC Any command Eg d-exec kubectl get nodes // d-exec helm list 
	docker exec  ${CONTAINER_NAME} $(command)
