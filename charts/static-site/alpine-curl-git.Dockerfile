FROM alpine/git:v2.40.1@sha256:9a2947ae3651a9db60411eabb254fab595ee7fbd37817020ff7e43f0f2c463e3
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git