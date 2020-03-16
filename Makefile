.PHONY: build

APP_NAME ?= `grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g'`
APP_VSN ?= `grep 'version:' mix.exs | cut -d '"' -f2`
BUILD ?= `git rev-parse --short HEAD`
DOCKERHUB_USERNAME ?= duderman

build:
	docker build \
		--build-arg APP_NAME=$(APP_NAME) \
		--build-arg APP_VSN=$(APP_VSN) \
		-t $(DOCKERHUB_USERNAME)/$(APP_NAME):latest \
		-t $(DOCKERHUB_USERNAME)/$(APP_NAME):$(BUILD) \
		.

push:
	docker push $(DOCKERHUB_USERNAME)/$(APP_NAME):latest && \
	docker push $(DOCKERHUB_USERNAME)/$(APP_NAME):$(BUILD)

rollout:
	kubectl set image deployment/web web=$(DOCKERHUB_USERNAME)/$(APP_NAME):$(BUILD)

deploy: build push rollout
