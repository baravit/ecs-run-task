VERSION=$(shell git describe --tags --candidates=1 --dirty 2>/dev/null || echo "dev")
FLAGS=-s -w -X main.Version=$(VERSION)
SRC=$(shell find . -type f -name '*.go' -not -path "./vendor/*")

ecs-run: $(SRC)
	go build -o ecs-run -ldflags="$(FLAGS)" -v .

.PHONY: test
test:
	gofmt -s -l -w $(SRC)
	go vet -v ./...
	go test -race -v ./...

.PHONY: clean
clean:
	rm -f ecs-run

.PHONY: release
release:
	go get github.com/mitchellh/gox
	gox -ldflags="$(FLAGS)" -output="build/{{.Dir}}-{{.OS}}-{{.Arch}}" -osarch="linux/amd64 windows/amd64" .
