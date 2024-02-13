FROM alpine/git:v2.43.0@sha256:36f8916f1953ed812eafe54e2134aa9cf215799d3b832ae163f5fa3f09026880
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git