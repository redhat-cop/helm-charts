FROM alpine/git:v2.47.2@sha256:0ab86d3dcca6ee5cf3d6677eab1d1bde5b5525f533ea6b91f3213813d6c0085d
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git
