FROM golang:1.16

WORKDIR /go/src/leanote

RUN go version \
    && go get -u github.com/revel/cmd/revel \
    && revel version

RUN apt-get update && apt-get install -y rsync

WORKDIR /go/src/leanote/sh

CMD ./release.sh
