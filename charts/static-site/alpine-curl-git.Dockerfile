FROM alpine/git:v2.43.0@sha256:f0c544b406f4ead9788320e2d9210e344a46ccaabedeac25668c15968b10cb6d
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git