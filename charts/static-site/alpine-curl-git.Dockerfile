FROM alpine/git:2.43.4@sha256:bfbb9643e2e167e540dedaa76e2f51f998ae7ce9b85d38112dfcd9bc156f98fa
RUN apk add --no-cache curl

ENTRYPOINT ["/bin/sh"]

# docker build . -f ./alpine-curl-git.Dockerfile -t jijiechen/alpine-curl-git:v2.24.1
# https://hub.docker.com/r/jijiechen/alpine-curl-git