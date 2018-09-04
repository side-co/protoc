FROM znly/protoc:0.3.0

WORKDIR /

RUN apk update \
    # Update and upgrade alpine packages
    && apk upgrade \
    # Install required pakcages
    && apk --no-cache add make openssh git docker

EXPOSE 2000/udp

CMD ["bash"]