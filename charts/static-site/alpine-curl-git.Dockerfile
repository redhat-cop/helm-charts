FROM alpine/git:v2.47.1@sha256:39ac44ff6c6f659ee55eedd221a6b7e4cdfcf9d17ea2be024f588c3ddcd3ce7d
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git