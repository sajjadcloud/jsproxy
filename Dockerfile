FROM openresty/openresty:alpine

ARG VERSION=0.1.0

RUN set -ex \
  && apk add --no-cache --update curl
  
RUN set -ex \
  
  && curl -o jsproxy.tar.gz https://codeload.github.com/EtherDream/jsproxy/tar.gz/${VERSION} \
  && tar zxf jsproxy.tar.gz \
  && rm -f jsproxy.tar.gz \ 

  && curl -o www.tar.gz https://codeload.github.com/EtherDream/jsproxy/tar.gz/gh-pages \
  && tar zxf www.tar.gz -C jsproxy-${VERSION}/www --strip-components=1 \
  && rm -f www.tar.gz \
  
  && mv jsproxy-* server
  
EXPOSE 8080 8443
VOLUME /mnt /config

CMD ["openresty", "-c", "/server/nginx.conf", "-p", "/server/nginx","-g","daemon off;"]
