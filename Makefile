BIN = graylog-project
BIN_LINUX = $(BIN).linux
BIN_DARWIN = $(BIN).darwin

GIT_REV=$(shell git rev-parse --short HEAD)
BUILD_DATE=$(shell date -u +%Y-%m-%dT%H:%M:%S%z)
GIT_TAG=$(shell git describe --tags --abbrev=0 --dirty)
BUILD_OPTS = -mod=vendor -ldflags "-s -X github.com/Graylog2/graylog-project-cli/cmd.gitRevision=$(GIT_REV) -X github.com/Graylog2/graylog-project-cli/cmd.buildDate=$(BUILD_DATE) -X github.com/Graylog2/graylog-project-cli/cmd.gitTag=$(GIT_TAG)"

all: test build

build: build-linux build-darwin

build-linux:
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build $(BUILD_OPTS) -o $(BIN_LINUX) main.go

build-darwin:
	GOOS=darwin GOARCH=amd64 CGO_ENABLED=0 go build $(BUILD_OPTS) -o $(BIN_DARWIN) main.go

install: install-linux install-darwin

install-darwin: build-darwin
	install -m 555 $(BIN_DARWIN) $(HOME)/bin/$(BIN)

install-linux: build-linux
	install -m 555 $(BIN_LINUX) $(HOME)/bin/$(BIN)

fmt:
	go fmt ./...

vet:
	go vet ./...

test:
	go test -mod=vendor ./...

clean:
	rm -f $(BIN_LINUX) $(BIN_DARWIN)
