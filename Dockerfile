FROM php:7.4-apache

RUN apt-get update \
&& apt-get install -y wget unzip vim sudo

RUN docker-php-ext-install -j$(nproc) mysqli

RUN set -eux; apt-get update; apt-get install -y libzip-dev

RUN apt-get update \
  && apt-get install -f -y --no-install-recommends openssh-server \
  rsync \
  netcat \
  curl \
  libicu-dev \
  libmemcached-dev \
  libz-dev \
  libpq-dev \
  libjpeg-dev \
  libfreetype6-dev \
  libmcrypt-dev \
  libbz2-dev \
  libjpeg62-turbo-dev \
  gnupg \
  libldap2-dev \
  libpng-dev \
  libxslt-dev \
  unixodbc-dev \
  uuid-dev \
  ghostscript \
  libaio1 \
  libgss3 \
  libxslt1.1 \
  locales \
  sassc \
  unixodbc \
  unzip \
  zip \
  libmemcached11 \
  libldap-2.4-2

#instala??o de extens?es de php para que funcione corretamente
RUN docker-php-ext-configure soap --enable-soap \
&& docker-php-ext-configure bcmath --enable-bcmath \
&& docker-php-ext-configure pcntl --enable-pcntl \
&& docker-php-ext-configure zip \
&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
&& docker-php-ext-install -j$(nproc) zip opcache pgsql intl soap xmlrpc bcmath pcntl sockets ldap iconv

RUN docker-php-ext-configure gd \
    --with-freetype=/usr/include/ \
    --with-jpeg=/usr/include/ \
    --enable-gd

RUN docker-php-ext-install gd

RUN pecl install apcu igbinary memcached uuid xmlrpc-beta \
&& docker-php-ext-enable apcu igbinary memcached uuid xmlrpc

#RUN apt-get autopurge -y \
#    && apt-get autoremove -y \
#    && apt-get autoclean \

#RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

#RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

#COPY ./meuconf.conf /usr/local/apache/conf/extra/httpd-vhosts.conf

#
# TODO: Aplicação vir de um repositório GIT
#
COPY ./app_ead/ /var/www/html/

RUN mkdir -p /storeazurefiles
COPY ./moodledata.zip /storeazurefiles

RUN unzip /storeazurefiles/moodledata.zip -d /storeazurefiles

RUN rm -fr /storeazurefiles/cache/*
RUN rm -fr /storeazurefiles/session/*
RUN rm -fr /storeazurefiles/temp/*

RUN rm -fr /etc/apache2/sites-available/*

COPY ./default-ssl.conf /etc/apache2/sites-available/
COPY ./000-default.conf /etc/apache2/sites-available/

RUN chown -R www-data.www-data /storeazurefiles/
RUN chown -R www-data.www-data /var/www/html/

WORKDIR /var/www/html

RUN usermod -aG sudo www-data

RUN mkdir -p /run/sshd && echo "root:Docker!" | chpasswd
COPY sshd_config /etc/ssh/

#Dar permissoes de usuario a pasta
#RUN chown www-data.www-data /var/www/html -R

# Open port 2222 for SSH access
EXPOSE 80
EXPOSE 2222
EXPOSE 443

ENTRYPOINT ["/bin/bash", "-c", "/usr/sbin/sshd"]



