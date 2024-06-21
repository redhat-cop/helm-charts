FROM alpine/git:v2.43.0@sha256:5be7ad4ab6bbd7f24a66224c814aa030c2abad186d839c8b6c1210585d96e25c
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git