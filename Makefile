# Goals:
# - user can build binaries on their system without having to install special tools
# - user can fork the canonical repo and expect to be able to run CircleCI checks
#
# This makefile is meant for humans

VERSION := $(shell git describe --tags --always --dirty="-dev")
LDFLAGS := -ldflags='-X "main.Version=$(VERSION)"'

test:
	GO111MODULE=on go test -v ./...

all: depend dist/aws-okta-$(VERSION)-darwin-amd64 dist/aws-okta-$(VERSION)-linux-amd64 dist/aws-okta-$(VERSION)-linux-arm64

depend:
	@echo "Updating go mods"
	go get -u golang.org/x/sys
	go mod vendor

clean:
	rm -rf ./dist

dist/:
	mkdir -p dist

dist/aws-okta-$(VERSION)-darwin-amd64: | dist/
	GOOS=darwin GOARCH=amd64 GO111MODULE=on go build $(LDFLAGS) -o $@

dist/aws-okta-$(VERSION)-linux-amd64: | dist/
	GOOS=linux GOARCH=amd64 GO111MODULE=on go build $(LDFLAGS) -o $@

dist/aws-okta-$(VERSION)-linux-arm64: | dist/
	GOOS=linux GOARCH=arm64 GO111MODULE=on go build -mod=vendor $(LDFLAGS) -o $@

.PHONY: clean all
