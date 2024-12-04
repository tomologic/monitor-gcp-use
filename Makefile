.PHONY: build rmi

build:
	docker build --platform linux/amd64 -t tomologic/$(shell basename $(CURDIR)) .

rmi:
	docker rmi tomologic/$(shell basename $(CURDIR))
