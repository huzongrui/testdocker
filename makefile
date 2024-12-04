TARGET = testdocker
SOURCE = .
LOGS = logs
VIEWS = views
VENDOR = vendor

IMAGE = crpi-p6x0x9yzk6kuewlv.cn-shanghai.personal.cr.aliyuncs.com/mytest_hzr/testdocker
TAG = latest

REPO = github.com
USERNAME = username
PASSWORD = password

LINTER = golangci-lint
GO = go
DOCKER = docker
RM = rm

all: build

build: $(TARGET)

dep: $(VENDOR)

$(TARGET): dep
	$(GO) build -o $@ $(SOURCE)

prestep: $(LOGS) $(VIEWS)

$(LOGS):
	if [ ! -d $(LOGS) ]; then mkdir -p $(LOGS); fi

$(VIEWS):
	if [ ! -d $(VIEWS) ]; then mkdir -p $(LOGS); fi

$(VENDOR):
	if [ ! -d $(VENDOR) ]; then go mod vendor; fi

lint:
	$(LINTER) run ./...

test:
	$(GO) test -v ./...

deploy: image push

image:
	$(DOCKER) build --platform=linux/amd64 --force-rm -t $(IMAGE):$(TAG) .

push:
	$(DOCKER) push $(IMAGE):$(TAG)

.PHONY: clean cleanlogs cleandep cleanimage cleanall
clean:
	$(RM) -f $(TARGET)

cleanlogs:
	$(RM) -rf $(LOGS)/*

cleandep:
	$(RM) -rf $(VENDOR)
	$(RM) -rf $(LOGS)

cleanimage:
	$(DOCKER) rmi $(IMAGE):$(shell $(DOCKER) images $(IMAGE) --format "{{.Tag}}")
	$(DOCKER) rmi $(shell $(DOCKER) images --filter "dangling=true" -q)

cleanall: clean cleanlogs