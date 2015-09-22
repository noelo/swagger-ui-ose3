FROM centos:centos7
MAINTAINER Jorge Morales<jmorales@redhat.com>

ENV HOME=/opt

RUN rpmkeys --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
    yum install -y http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm && \
    yum install -y --setopt=tsflags=nodocs nginx tar && \
    yum clean all -y && \
    mkdir -p ${HOME} && \
    groupadd -r default -f -g 1001 && \
    useradd -u 1001 -r -g default -d ${HOME} -s /sbin/nologin -c "Default User" default && \
    chown -R 1001:1001 $HOME

EXPOSE 8480

COPY files/swagger.conf /etc/nginx/conf.d/default.conf
COPY files/nginx.conf /etc/nginx/nginx.conf

#RUN echo 'daemon off;' >> /etc/nginx/nginx.conf
#RUN echo 'error_log /tmp/error.log warn;'

ENV SWAGGERUI_VERSION 2.1.2
RUN cd /tmp && \
    curl -Lk https://github.com/swagger-api/swagger-ui/archive/v${SWAGGERUI_VERSION}.tar.gz -o swagger-ui-${SWAGGERUI_VERSION}.tar.gz  && \
    tar -xzf swagger-ui-${SWAGGERUI_VERSION}.tar.gz && \
    mkdir -p $HOME/swagger-ui && \
    mv swagger-ui-${SWAGGERUI_VERSION}/dist/* $HOME/swagger-ui && \
    rm -rf swagger-ui-${SWAGGERUI_VERSION}*

WORKDIR $HOME

ENTRYPOINT nginx
