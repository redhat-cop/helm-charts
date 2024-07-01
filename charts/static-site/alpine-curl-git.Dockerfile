FROM alpine/git:2.45.2@sha256:81d709a676f9d46d12a414777335444dad68c33dac0a6a6022c8c886314ca612
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git