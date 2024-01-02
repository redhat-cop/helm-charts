FROM alpine/git:v2.43.0@sha256:67da6fd35e0fad358d37e739020cff40aa02ecce04e13f5454a6a0a45e0a536a
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git