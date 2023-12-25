FROM alpine/git:v2.43.0@sha256:faf69528bd66119fd9295462e486bd30ec1cc1372c88bfd281cebff6cd502f53
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git