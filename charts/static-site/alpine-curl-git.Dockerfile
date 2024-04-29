FROM alpine/git:v2.43.0@sha256:cc344fd764d5a86be67f8e86b11692001525938e94dfd4a0395833fa2bb3459e
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git