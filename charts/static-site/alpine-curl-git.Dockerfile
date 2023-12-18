FROM alpine/git:v2.43.0@sha256:1031f50b5bdda7eee6167e362cff09b8c809889cd43e5306abc5bf6438e68890
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git