FROM znly/protoc:latest

WORKDIR /

RUN apk update \
    # Update and updgrage alpine packages
    && apk upgrade \
    # Install required pakcages
    && apk --no-cache add bash docker git make openssh

EXPOSE 2000/udp

CMD ["bash"]