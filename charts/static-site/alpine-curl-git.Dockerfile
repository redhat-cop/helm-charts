FROM alpine/git:2.45.2@sha256:0f018c79d7467f7b4cc6c00e1508e71cf107ed2cac2315e5d3ea62d0224968e1
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git