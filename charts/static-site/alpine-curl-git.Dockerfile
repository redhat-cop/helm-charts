FROM alpine/git:v2.43.0@sha256:7ad46fb5a06ff6deb92edede9da5939edc1a1ec3383a4f58e3d8f3400e04ebe7
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git