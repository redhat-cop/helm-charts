FROM alpine/git:v2.43.0@sha256:1059ec0771f6b9d59d219230d5cdbcc1c01bfa7b5c2cde6ebe3efdc92e8da95c
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git