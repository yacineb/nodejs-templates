GIT_REV=$(shell git log -1 --format=%h)
NPM_VER=$(shell node -pe "require('./package.json').version")
VERSION='$(NPM_VER)-$(GIT_REV)'

# import deploy config
# You can change the default deploy config by passing this argument make cli `conf="deploy_special.env"`
conf ?= deploy.env
include $(conf)
export $(shell sed 's/=.*//' $(conf))

.PHONY: help

#t hanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## shows cli help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# define default make cli entrypoint
.DEFAULT_GOAL := help

#----------------
# Docker CI commands
#----------------
build: ## build docker image
	docker build -t $(APP_NAME) .

build-nocache: ## build the container without caching
	docker build --no-cache -t $(APP_NAME) .

tag-latest: ## Generate container `{version}` tag
	@echo 'create tag latest'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):latest

tag-version: ## Generate container `latest` tag
	@echo 'create tag $(VERSION)'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

tag: tag-latest tag-version ## Generate container tags for the `{version}` ans `latest` tags

run: ## Run container on port configured in `config.env` with the given versionned tag
	docker run -d -p=$(PORT_EXT):$(PORT) --name="$(APP_NAME)" $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

run-latest: ## Run container on port configured in `config.env` with latest tag
	docker run -d -p=$(PORT_EXT):$(PORT) --name="$(APP_NAME)" $(DOCKER_REPO)/$(APP_NAME):latest


stop: ## Stop and current container and remove unused ones
	docker ps -q --filter name=$(APP_NAME) | xargs -r docker stop
	docker container prune -f

publish: publish-latest publish-version ## Publish the `{version}` ans `latest` tagged containers to ECR

publish-latest: tag-latest ## Publish the `latest` tagged container to ECR
	@echo 'publish latest to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):latest

publish-version: tag-version ## Publish the `{version}` tagged container to ECR
	@echo 'publish $(VERSION) to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

#--------
# Helpers
#--------
.PHONY: container-ver npm-ver git-rev

git-rev: ## shows current git revision id
	@echo $(GIT_REV)

npm-ver: ## shows npm package version
	@echo $(NPM_VER)

container-ver: ## shows docker container version
	@echo $(VERSION)
