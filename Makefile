# Copyright 2014-2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
# 	http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

PAUSE_CONTAINER_IMAGE = "amazon/amazon-ecs-pause"
PAUSE_CONTAINER_TAG = "0.1.0"
PAUSE_CONTAINER_TARBALL = "amazon-ecs-pause.tar"

# Variable to determine branch/tag of amazon-ecs-cni-plugins
ECS_CNI_REPOSITORY_REVISION=master

.PHONY: all gobuild static docker release certs test clean netkitten test-registry run-functional-tests gremlin benchmark-test gogenerate run-integ-tests image-cleanup-test-images pause-container get-cni-sources cni-plugins

all: docker

# Dynamic go build; useful in that it does not have -a so it won't recompile
# everything every time
gobuild:
	./scripts/build false

# Basic go build
static:
	./scripts/build

# 'build-in-docker' builds the agent within a dockerfile and saves it to the ./out
# directory
build-in-docker:
	@docker build -f scripts/dockerfiles/Dockerfile.build -t "amazon/amazon-ecs-agent-build:make" .
	@docker run --net=none \
	  -e TARGET_OS="${TARGET_OS}" \
	  -e LDFLAGS="-X github.com/aws/amazon-ecs-agent/agent/config.PauseContainerTag=$(PAUSE_CONTAINER_TAG) \
	  -X github.com/aws/amazon-ecs-agent/agent/config.PauseContainerImageName=$(PAUSE_CONTAINER_IMAGE)" \
	  -v "$(shell pwd)/out:/out" \
	  -v "$(shell pwd):/go/src/github.com/aws/amazon-ecs-agent" \
	  "amazon/amazon-ecs-agent-build:make"

# 'docker' builds the agent dockerfile from the current sourcecode tree, dirty
# or not
docker: certs build-in-docker pause-container-release
	@cd scripts && ./create-amazon-ecs-scratch
	@docker build -f scripts/dockerfiles/Dockerfile.release -t "amazon/amazon-ecs-agent:make" .
	@echo "Built Docker image \"amazon/amazon-ecs-agent:make\""

# 'docker-release' builds the agent from a clean snapshot of the git repo in
# 'RELEASE' mode
docker-release: pause-container-release cni-plugins
	@docker build -f scripts/dockerfiles/Dockerfile.cleanbuild -t "amazon/amazon-ecs-agent-cleanbuild:make" .
	@docker run --net=none \
	  -e TARGET_OS="${TARGET_OS}" \
	  -v "$(shell pwd)/out:/out" \
	  -e LDFLAGS="-X github.com/aws/amazon-ecs-agent/agent/config.PauseContainerTag=$(PAUSE_CONTAINER_TAG) \
	  -X github.com/aws/amazon-ecs-agent/agent/config.PauseContainerImageName=$(PAUSE_CONTAINER_IMAGE)" \
	  -v "$(shell pwd):/src/amazon-ecs-agent" \
	  "amazon/amazon-ecs-agent-cleanbuild:make"

# Release packages our agent into a "scratch" based dockerfile
release: certs docker-release
	@./scripts/create-amazon-ecs-scratch
	@docker build -f scripts/dockerfiles/Dockerfile.release -t "amazon/amazon-ecs-agent:latest" .
	@echo "Built Docker image \"amazon/amazon-ecs-agent:latest\""

gogenerate:
	./scripts/gogenerate

# We need to bundle certificates with our scratch-based container
certs: misc/certs/ca-certificates.crt
misc/certs/ca-certificates.crt:
	docker build -t "amazon/amazon-ecs-agent-cert-source:make" misc/certs/
	docker run "amazon/amazon-ecs-agent-cert-source:make" cat /etc/ssl/certs/ca-certificates.crt > misc/certs/ca-certificates.crt

test:
	. ./scripts/shared_env && go test -timeout=25s -v -cover $(shell go list ./agent/... | grep -v /vendor/)

test-silent:
	. ./scripts/shared_env && go test -timeout=25s -cover $(shell go list ./agent/... | grep -v /vendor/)

benchmark-test:
	. ./scripts/shared_env && go test -run=XX -bench=. $(shell go list ./agent/... | grep -v /vendor/)

# Run our 'test' registry needed for integ and functional tests
test-registry: netkitten volumes-test squid awscli image-cleanup-test-images fluentd
	@./scripts/setup-test-registry

test-in-docker:
	docker build -f scripts/dockerfiles/Dockerfile.test -t "amazon/amazon-ecs-agent-test:make" .
	# Privileged needed for docker-in-docker so integ tests pass
	docker run -v "$(shell pwd):/go/src/github.com/aws/amazon-ecs-agent" --privileged "amazon/amazon-ecs-agent-test:make"

run-functional-tests: testnnp test-registry
	. ./scripts/shared_env && go test -tags functional -timeout=30m -v ./agent/functional_tests/...

testnnp:
	cd misc/testnnp; $(MAKE) $(MFLAGS)

pause-container:
	@docker build -f scripts/dockerfiles/Dockerfile.buildPause -t "amazon/amazon-ecs-build-pause-bin:make" .
	@docker run --net=none \
		-v "$(shell pwd)/misc/pause-container:/out" \
		-v "$(shell pwd)/misc/pause-container/buildPause:/usr/src/buildPause" \
		"amazon/amazon-ecs-build-pause-bin:make"

	cd misc/pause-container; $(MAKE) $(MFLAGS)
	@docker rmi -f "amazon/amazon-ecs-build-pause-bin:make"

pause-container-release: pause-container
	mkdir -p "$(shell pwd)/out"
	@docker save ${PAUSE_CONTAINER_IMAGE}:${PAUSE_CONTAINER_TAG} > "$(shell pwd)/out/${PAUSE_CONTAINER_TARBALL}"

get-cni-sources:
	@git clone https://github.com/aws/amazon-ecs-cni-plugins.git --branch $(ECS_CNI_REPOSITORY_REVISION)

cni-plugins:
	@docker build -f scripts/dockerfiles/Dockerfile.buildCNIPlugins -t "amazon/amazon-ecs-build-cniplugins:make" .
	@docker run --rm --net=none \
		-v "$(shell pwd)/out/cni-plugins:/go/src/github.com/aws/amazon-ecs-cni-plugins/bin/plugins" \
		-v "$(shell pwd)/amazon-ecs-cni-plugins:/go/src/github.com/aws/amazon-ecs-cni-plugins" \
		"amazon/amazon-ecs-build-cniplugins:make"

	@echo "Built amazon-ecs-cni-plugins successfully."

run-integ-tests: test-registry gremlin
	. ./scripts/shared_env && go test -tags integration -timeout=5m -v ./agent/engine/... ./agent/stats/... ./agent/app/...

netkitten:
	cd misc/netkitten; $(MAKE) $(MFLAGS)

volumes-test:
	cd misc/volumes-test; $(MAKE) $(MFLAGS)

# TODO, replace this with a build on dockerhub or a mechanism for the
# functional tests themselves to build this
.PHONY: squid awscli fluentd
squid:
	cd misc/squid; $(MAKE) $(MFLAGS)

gremlin:
	cd misc/gremlin; $(MAKE) $(MFLAGS)

awscli:
	cd misc/awscli; $(MAKE) $(MFLAGS)

fluentd:
	cd misc/fluentd; $(MAKE) $(MFLAGS)

image-cleanup-test-images:
	cd misc/image-cleanup-test-images; $(MAKE) $(MFLAGS)

get-deps:
	go get github.com/tools/godep
	go get golang.org/x/tools/cmd/cover
	go get github.com/golang/mock/mockgen
	go get golang.org/x/tools/cmd/goimports


clean:
	# ensure docker is running and we can talk to it, abort if not:
	docker ps > /dev/null
	rm -f misc/certs/ca-certificates.crt &> /dev/null
	rm -rf out/*
	rm -rf $(shell pwd)/amazon-ecs-cni-plugins
	rm -rf agent/Godeps/_workspace/pkg/
	-$(MAKE) -C misc/netkitten $(MFLAGS) clean
	-$(MAKE) -C misc/volumes-test $(MFLAGS) clean
	-$(MAKE) -C misc/gremlin $(MFLAGS) clean
	-$(MAKE) -C misc/testnnp $(MFLAGS) clean
	-$(MAKE) -C misc/image-cleanup-test-images $(MFLAGS) clean
