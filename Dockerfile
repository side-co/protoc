FROM golang:alpine AS protoc_plugins

RUN apk --no-cache add git \
    && go get -u \
    github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc \
    github.com/golang/protobuf/protoc-gen-go \ 
    github.com/ckaznocha/protoc-gen-lint 

FROM alpine:latest

WORKDIR /

# Required packages:
#   - bash: run bash scripts
#   - git: pull / push generated code
#   - make: use Makefile 
#   - openssh: clone git repos
#   - protobuf: generate code from .proto files
#   - protoc-gen-doc: generates a documentation from .proto files
#   - protoc-gen-go: generates go code from .proto files
#   - protoc-gen-lint: lint .proto files

COPY --from=protoc_plugins /go/bin/protoc-gen-go /usr/local/bin
COPY --from=protoc_plugins /go/bin/protoc-gen-doc /usr/local/bin
COPY --from=protoc_plugins /go/bin/protoc-gen-lint /usr/local/bin

RUN apk update \
    # Update and updgrage alpine packages
    && apk upgrade \
    # Install required pakcages
    && apk --no-cache add bash git make openssh protobuf

EXPOSE 2000/udp

CMD ["bash"]