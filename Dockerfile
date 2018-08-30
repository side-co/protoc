FROM znly/protoc

WORKDIR /

RUN apk update \
    # Update and updgrage alpine packages
    && apk upgrade \
    # Install required pakcages
    && apk --no-cache add make openssh git docker

EXPOSE 2000/udp

CMD ["bash"]