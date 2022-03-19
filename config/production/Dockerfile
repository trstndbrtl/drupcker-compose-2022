#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

# from https://www.drupal.org/docs/system-requirements/php-requirements
FROM php:7.4-apache-buster

# install the PHP extensions we need
RUN set -eux; \
	\
	if command -v a2enmod; then \
		a2enmod rewrite; \
	fi; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libfreetype6-dev \
		libjpeg-dev \
		libpng-dev \
		libpq-dev \
		libzip-dev \
	; \
	\
	docker-php-ext-configure gd \
		--with-freetype \
		--with-jpeg=/usr \
	; \
	\
	docker-php-ext-install -j "$(nproc)" \
		gd \
		opcache \
		pdo_mysql \
		pdo_pgsql \
		zip \
	; \
	\
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=512'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/

WORKDIR /opt/drupal

RUN set -eux; \
	export COMPOSER_HOME="$(mktemp -d)"; \
  chown -R www-data:www-data /opt/drupal; \
	rmdir /var/www/html; \
	ln -sf /opt/drupal/web /var/www/html; \
	# delete composer cache
	rm -rf "$COMPOSER_HOME"

# Custom Script
# Copy all custom drupal file on the container
COPY ./config/prod/apache2/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY ./var/html/config /opt/drupal/config
COPY ./var/html/translations /opt/drupal/translations
COPY ./var/html/web/sites/default/settings.php /opt/drupal/web/sites/default/settings.php
COPY ./var/html/web/libraries /opt/drupal/web/libraries
COPY ./var/html/web/profiles /opt/drupal/web/profiles
COPY ./var/html/web/themes/custom /opt/drupal/web/themes/custom
COPY ./var/html/web/modules/custom /opt/drupal/web/modules/custom
COPY ./var/html/composer.json /opt/drupal/composer.json

# Add composer path to path server
ENV PATH=${PATH}:/opt/drupal/vendor/bin

# Install composer stuff
RUN composer install --no-dev

# Run entrypoint script
COPY ./config/production/entrypoint.sh /opt/drupal/entrypoint.sh
RUN chmod +x /opt/drupal/entrypoint.sh
ENTRYPOINT ["/opt/drupal/entrypoint.sh"]
CMD ["apache2-foreground"]
# vim:set ft=dockerfile: