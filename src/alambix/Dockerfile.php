# Image PHP 7.4, fpm par socket

FROM php:7.4-fpm-alpine

WORKDIR /usr/local

# supprimer ce qui vient de docker dans la configuration php
RUN rm etc/php-fpm.d/*.conf \
# configurer locales et timezone puis ajouter une série de binaires utiles
    && apk add --update bash tzdata ssmtp oniguruma-dev \
    && cp /usr/share/zoneinfo/Europe/Paris /etc/localtime \
    && echo "Europe/Paris" > /etc/timezone \
    && apk del tzdata \
    && apk add ghostscript freetype-dev icu-dev libjpeg-turbo-dev libpng-dev graphicsmagick zlib-dev libzip-dev \
    # nettoyage
    && rm -rf /var/cache/apk/* \
              /tmp/* \
    \
# installer les extensions PHP nécessaires
    && docker-php-ext-configure intl --enable-intl \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ \
	                               --with-jpeg=/usr/include/ \
    && docker-php-ext-configure zip \
    && docker-php-ext-install -j$(nproc) gd \
                                         intl \
                                         mysqli \
                                         mbstring \
                                         pdo_mysql \
                                         zip \
    \
# débloquer configuration d'openssl sur Alpine
    && sed -i 's/#default_bits/default_bits/g' /etc/ssl/openssl.cnf \
    && sed -i 's/#default_md/default_md/g' /etc/ssl/openssl.cnf \
    \
# ajout d'éléments de confort
    && echo "ls -alh \$*" > /usr/local/bin/ll \
    && chmod a+x /usr/local/bin/ll