FROM centos:latest
MAINTAINER "The CentOS Project" <admin@jiobxn.com>
ARG LATEST="0"

RUN yum clean all; yum -y update; yum -y install net-tools sudo make gcc-c++ git iptables ipset; yum clean all \
  && cd /mnt/ \
    && curl -s -O https://www.openssl.org/source/openssl-1.1.1b.tar.gz && tar zxf openssl-* \
    && curl -s -O https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz && tar zxf pcre-* \
    && curl -s -O https://zlib.net/zlib-1.2.11.tar.gz && tar zxf zlib-* \
    && curl -s -O https://openresty.org/download/openresty-1.15.8.1.tar.gz && tar zxf openresty-* \
    && cd openresty-1.15.8.1 \
    && ./configure \
        --with-openssl=../openssl-1.1.1b \
        --with-pcre=../pcre-8.43 \
        --with-zlib=../zlib-1.2.11 \
        --with-http_v2_module \
        --with-http_ssl_module \
        --with-pcre-jit \
        --prefix=/openresty \
    && make -j8 && make install \
    && rm -rf /mnt/* \
  && cd / \
    && git clone --depth=1 https://github.com/EtherDream/jsproxy.git server \
    && cd server && rm -rf www \
    && git clone -b gh-pages --depth=1 https://github.com/EtherDream/jsproxy.git www \
  && yum remove make gcc-c++ git -y 

RUN useradd jsproxy -g nobody \
    && chown -R jsproxy.nobody /openresty \
    && chown -R jsproxy.nobody /server

VOLUME /key

COPY jsproxy.sh /jsproxy.sh
RUN chmod +x /jsproxy.sh

ENTRYPOINT ["/jsproxy.sh"]

EXPOSE 8080 8443

CMD ["jsproxy"]
