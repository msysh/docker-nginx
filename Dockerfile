FROM alpine:latest

ENV NGINX_VERSION 1.12.2

RUN apk --update add pcre-dev openssl-dev \
  && apk add --virtual build-dependencies build-base curl \
  && curl -SLO http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
  && tar zxf nginx-${NGINX_VERSION}.tar.gz \
  && cd nginx-${NGINX_VERSION} \
  && ./configure \
      --prefix=/usr/share/nginx \
      --sbin-path=/usr/local/sbin/nginx \
      --conf-path=/etc/nginx/conf/nginx.conf \
      --pid-path=/var/run/nginx.pid \
      --http-log-path=/var/log/nginx/access.log \
      --error-log-path=/var/log/nginx/error.log \
      --with-pcre \
      --with-http_gzip_static_module \
      --with-http_ssl_module \
      --with-http_secure_link_module \
      --with-http_stub_status_module \
      --with-http_realip_module \
      --with-threads \
      --with-stream \
      --with-stream_realip_module \
      --with-stream_ssl_module \
      --with-stream_ssl_preread_module \
  && make \
  && make install \
  && mkdir /etc/nginx/conf/conf.d \
  && ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log \
  && cd / \
  && apk del build-dependencies \
  && rm -rf \
       nginx-${NGINX_VERSION} \
       nginx-${NGINX_VERSION}.tar.gz \
       /var/cache/apk/*

VOLUME ["/var/cache/nginx", "/etc/nginx/conf/conf.d"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]

