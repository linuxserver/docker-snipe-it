FROM lsiobase/alpine.nginx:3.7

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SNIPEIT_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="TheLamer"

RUN \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
   curl \
   libxml2 \
   php7-bcmath \
   php7-ctype \
   php7-curl \
   php7-gd \
   php7-ldap \
   php7-mbstring \
   php7-mcrypt \
   php7-phar \
   php7-pdo_mysql \
   php7-pdo_sqlite \
   php7-sqlite3 \
   php7-tokenizer \
   php7-xml \
   php7-xmlreader \
   php7-zip \
   tar \
   unzip && \
 echo "**** configure php and nginx for snipe-it ****" && \
 sed -i \
   -e 's/;opcache.enable.*=.*/opcache.enable=1/g' \
   -e 's/;opcache.interned_strings_buffer.*=.*/opcache.interned_strings_buffer=8/g' \
   -e 's/;opcache.max_accelerated_files.*=.*/opcache.max_accelerated_files=10000/g' \
   -e 's/;opcache.memory_consumption.*=.*/opcache.memory_consumption=128/g' \
   -e 's/;opcache.save_comments.*=.*/opcache.save_comments=1/g' \
   -e 's/;opcache.revalidate_freq.*=.*/opcache.revalidate_freq=1/g' \
   -e 's/;always_populate_raw_post_data.*=.*/always_populate_raw_post_data=-1/g' \
   -e 's/variables_order = .*/variables_order = "EGPCS"/' \
     /etc/php7/php.ini && \
 sed -i \
   '/opcache.enable=1/a opcache.enable_cli=1' \
     /etc/php7/php.ini && \
 sed -i \
  's/;clear_env = no/clear_env = no/g' \
    /etc/php7/php-fpm.d/www.conf && \
 echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> /etc/php7/php-fpm.conf && \
 echo "**** install snipe-it ****" && \
 mkdir -p \
   /var/www/html/ && \
 curl -o \
 /tmp/snipeit.tar.gz -L \
   https://github.com/snipe/snipe-it/archive/"${SNIPEIT_RELEASE}".tar.gz && \
 tar xf \
 /tmp/snipeit.tar.gz -C \
   /var/www/html/ --strip-components=1 && \
 cp /var/www/html/docker/docker.env /var/www/html/.env && \
 echo "**** Cleanup Directories and symlink storage ****" && \
 mkdir -p \
   "/config/dumps" \
   "/config/keys" \
   "/config/data" && \
 rm -rf "/var/www/html/storage/private_uploads" \
   "/var/www/html/public/uploads" \
   "/var/www/html/storage/app/backups" \
   "/var/www/html/storage/logs" \
   "/var/www/html/storage/framework" \
   "/var/www/html/storage/debugbar" && \
 ln -fs "/config/data/private_uploads" "/var/www/html/storage/private_uploads" && \
 ln -fs "/config/data/uploads" "/var/www/html/public/uploads" && \
 ln -fs "/config/dumps" "/var/www/html/storage/app/backups" && \
 ln -fs "/config/logs" "/var/www/html/storage/logs" && \
 ln -fs "/config/framework" "/var/www/html/storage/framework" && \
 ln -fs "/config/debugbar" "/var/www/html/storage/debugbar" && \
 ln -fs "/config/keys/oauth-private.key" "/var/www/html/storage/oauth-private.key" && \
 ln -fs "/config/keys/oauth-public.key" "/var/www/html/storage/oauth-public.key" && \
 echo "**** install dependencies ****" && \
 cd /tmp && \
 curl -sS https://getcomposer.org/installer | php && \
 mv /tmp/composer.phar /usr/local/bin/composer && \
 composer install -d /var/www/html && \
 echo "**** cleanup ****" && \
 rm -rf \
   /tmp/* \
   /root/.composer

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80
EXPOSE 443
VOLUME ["/config"]
