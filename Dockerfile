FROM 113.209.134.184:11880/fczy/alpine:3.15.0_aarch64

MAINTAINER https://github.com/caixiaoqiu87/fabric8-java-alpine-openjdk8-jre

USER root

RUN mkdir -p /deployments

# JAVA_APP_DIR is used by run-java.sh for finding the binaries
ENV JAVA_APP_DIR=/deployments \
    JAVA_MAJOR_VERSION=8

# /dev/urandom is used as random source, which is perfectly safe
# according to http://www.2uo.de/myths-about-urandom/
RUN apk add --update curl openjdk8-jre-base \
 && rm /var/cache/apk/* \
 && echo "securerandom.source=file:/dev/urandom" >> /usr/lib/jvm/default-jvm/jre/lib/security/java.security

#更新Alpine的软件源为国内（清华大学）的站点，因为从默认官源拉取实在太慢了。。。
RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.15/main/" > /etc/apk/repositories

#添加/bin/bash脚本
RUN apk update \
        && apk upgrade \
        && apk add --no-cache bash \
        bash-doc \
        bash-completion \
        && rm -rf /var/cache/apk/* \
        && /bin/bash

# Add run script as /deployments/run-java.sh and make it executable
COPY run-java.sh /deployments/
RUN chmod 755 /deployments/run-java.sh

CMD [ "/deployments/run-java.sh" ]
