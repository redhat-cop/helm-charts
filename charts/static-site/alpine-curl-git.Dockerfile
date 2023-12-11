FROM alpine/git:v2.43.0@sha256:3dae5e30932661beb65332fd874f7a652a88a4b0a46e3ffd819f095e3f3442fe
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git