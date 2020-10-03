FROM openshift/base-centos7

LABEL summary="Platform for building and running Angular applications on NGINX" \
    io.k8s.description="OpenShift S2I builder image for Angular apps using Angular CLI and NGINX 1.12.1." \
    io.k8s.display-name="Angular S2I NGINX" \
    io.openshift.expose-services="8080:http" \
    io.openshift.tags="builder,angular" \
    com.redhat.dev-mode="DEV_MODE:false" \
    com.redhat.deployments-dir="/opt/app-root/src" \
    com.redhat.dev-mode.port="DEBUG_PORT:5858" \
    io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"

EXPOSE 8080

# This image will be initialized with "npm run $NPM_RUN"
# See https://docs.npmjs.com/misc/scripts, and your repo's package.json
# file for possible values of NPM_RUN
ENV NODE_VERSION=10.0.0 \

    NPM_CONFIG_LOGLEVEL=info \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \

    NPM_VERSION=4.1.2 \
    DEBUG_PORT=5858 \
    NODE_ENV=production \
    DEV_MODE=false

# Install the nginx web server package and clean the yum cache
RUN yum install -y epel-release && \
    yum install -y --setopt=tsflags=nodocs nginx && \
    yum clean all

# Change the default port for nginx
# Required if you plan on running images as a non-root user).
RUN sed -i 's/80/8080/' /etc/nginx/nginx.conf
RUN sed -i 's/user nginx;//' /etc/nginx/nginx.conf

# Download and install a binary from nodejs.org
# Add the gpg keys listed at https://github.com/nodejs/node
RUN set -ex && \
    for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
    done && \
    yum install -y epel-release && \
    INSTALL_PKGS="bzip2 nss_wrapper" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    curl -o node-v${NODE_VERSION}-linux-x64.tar.gz -sSL https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz && \
    curl -o SHASUMS256.txt.asc -sSL https://nodejs.org/dist/v${NODE_VERSION}/SHASUMS256.txt.asc && \
    gpg --batch -d SHASUMS256.txt.asc | grep " node-v${NODE_VERSION}-linux-x64.tar.gz\$" | sha256sum -c - && \
    tar -zxf node-v${NODE_VERSION}-linux-x64.tar.gz -C /usr/local --strip-components=1 && \
    npm install -g npm@${NPM_VERSION} @angular/cli && \
    find /usr/local/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf; \
    rm -rf ~/node-v${NODE_VERSION}-linux-x64.tar.gz ~/SHASUMS256.txt.asc /tmp/node-v${NODE_VERSION} ~/.npm ~/.node-gyp ~/.gnupg \
    /usr/share/man /tmp/* /usr/local/lib/node_modules/npm/man /usr/local/lib/node_modules/npm/doc /usr/local/lib/node_modules/npm/html

# Copy the S2I scripts
COPY ./bin/ /usr/libexec/s2i

RUN chgrp -R 1001 /usr/share/nginx \
    && chmod -R 777 /usr/share/nginx
RUN chgrp -R 1001 /var/log/nginx \
    && chmod -R 777 /var/log/nginx
RUN chgrp -R 1001 /var/lib/nginx \
    && chmod -R 777 /var/lib/nginx
RUN chmod -R 777 /etc/nginx/
RUN chmod -R 777 /usr/libexec/s2i
RUN chmod +x /usr/libexec/s2i
RUN touch /run/nginx.pid
RUN chgrp -R 1001 /run/nginx.pid \
    && chmod -R 777 /run/nginx.pid

USER 1001

# Set the default port for applications built using this image
EXPOSE 8080

# Modify the usage script in your application dir to inform the user how to run
# this image.

CMD ["/usr/libexec/s2i/usage"]
