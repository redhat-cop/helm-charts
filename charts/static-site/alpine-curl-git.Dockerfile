FROM alpine/git:2.45.2@sha256:5ca30914aa0217893fc1ae63c3b56ddaa0aa1626de1278d0bbfae4f4f3a61173
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git