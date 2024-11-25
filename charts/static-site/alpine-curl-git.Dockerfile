FROM alpine/git:2.45.2@sha256:05fc2f890d86ecb0e71b6c6038baa140d4581b4f62509e3bf4dd386510becdfb
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git