FROM ubuntu:latest

WORKDIR /leanote

COPY . ./

VOLUME /leanote/files
VOLUME /leanote/public/upload

ENTRYPOINT ["./bin/run.sh"]
