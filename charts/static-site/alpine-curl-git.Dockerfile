FROM alpine/git:v2.43.0@sha256:7f7b65e67f9a3fb534fb4b69e885b7b96c8dce84b6f2df69db37456534f7fc62
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git