FROM golang:alpine3.10 AS protoc_plugins

ENV PROTO_GEN_GO_TAG=v1.3.1

RUN apk --no-cache add git \
    && go get -u \
    github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc \
    github.com/golang/protobuf/protoc-gen-go \ 
    github.com/ckaznocha/protoc-gen-lint \
    && git -C $GOPATH/src/github.com/golang/protobuf checkout $PROTO_GEN_GO_TAG \
    && go install github.com/golang/protobuf/protoc-gen-go

FROM alpine:3.12.3

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
    && apk --no-cache add bash git make openssh protobuf protobuf-dev 

EXPOSE 2000/udp

CMD ["bash"]