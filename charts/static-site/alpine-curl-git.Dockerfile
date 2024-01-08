FROM alpine/git:v2.43.0@sha256:b4985b08f07c7b0be4962f081c6836e2ea5d13bd57769a5a659a674d60b5e153
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git