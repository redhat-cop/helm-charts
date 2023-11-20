FROM alpine/git:v2.24.1@sha256:90185bacaffa02db620e907e34aeb5b53bbd85ace77f97db453355171c8f20d1
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git