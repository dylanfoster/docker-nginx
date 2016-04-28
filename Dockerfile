FROM dylanfoster/alpine
MAINTAINER Dylan Foster <dylan947@gmail.com>

RUN set -ex \
  && for key in \
    ABD4D3B3F5806B4D \
    518509686C7E5E82 \
    A9376139A524C53E \
    ECF0E90B2C172083 \
    520A9993A1C052F8 \
    ABF5BD827BD9BF62 \
    A64FD5B17ADB39A8 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

ENV NGINX_VERSION 1.9.11

RUN apk-install build-base curl openssl-dev pcre-dev zlib-dev \
 && curl -sSLO http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
 && curl -sSLO http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz.asc \
 && gpg --verify "nginx-${NGINX_VERSION}.tar.gz.asc" \
 && grep " node-v$NODE_VERSION.tar.xz\$" "nginx-${NGINX_VERSION}.tar.gz.asc" | sha256sum -c - \
 && tar -zxvf nginx-${NGINX_VERSION}.tar.gz \
 && cd /nginx-${NGINX_VERSION} \
 && ./configure \
      --conf-path=/etc/nginx/nginx.conf \
      --error-log-path=/var/log/nginx/error.log \
      --http-log-path=/var/log/nginx/access.log \
      --pid-path=/var/run/nginx.pid \
      --prefix=/etc/nginx \
      --sbin-path=/usr/local/sbin/nginx \
      --with-http_gzip_static_module \
      --with-http_ssl_module \
      --without-mail_imap_module \
      --without-mail_pop3_module \
      --without-mail_smtp_module \
 && make \
 && make install \
 && apk del build-base curl \
 && rm -rf \
      /nginx-${NGINX_VERSION} \
      /nginx-${NGINX_VERSION}.tar.gz \
      /nginx-${NGINX_VERSION}.tar.gz.asc

RUN mkdir -p /var/log/nginx
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir -p /data/http
ADD config /config
ADD etc /etc

VOLUME ["/data/http"]

EXPOSE 80 443
ENTRYPOINT ["/config/entrypoint.sh"]
CMD ["/usr/local/sbin/nginx"]
