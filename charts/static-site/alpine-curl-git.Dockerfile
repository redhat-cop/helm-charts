FROM alpine/git:v2.47.2@sha256:fb0b8c4c4062307b947101b301bae17d24d456055dd2265c659f93699f0dcc27
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git
