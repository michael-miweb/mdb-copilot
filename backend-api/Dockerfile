FROM dunglas/frankenphp:1-php8.4

WORKDIR /app

# Extensions PHP
RUN install-php-extensions pdo_mysql gd zip opcache intl pcntl && \
    apt-get update && apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copie du composer.json et lock pour cache des dépendances
COPY composer.json composer.lock ./

# Installation des dépendances (sans dev, sans scripts pour éviter artisan sans .env)
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-scripts

# Copie du code source
COPY --chown=www-data:www-data . /app

# Config PHP production
COPY docker/php/php.ini /usr/local/etc/php/conf.d/zzz-custom.ini

# Clear dev caches and regenerate package discovery without dev packages
RUN rm -f bootstrap/cache/packages.php bootstrap/cache/services.php && \
    php artisan package:discover --ansi

# Permissions
RUN chown -R www-data:www-data storage bootstrap/cache && \
    chmod -R 775 storage bootstrap/cache

# Variables d'environnement
ENV OCTANE_SERVER=frankenphp
ENV APP_ENV=production

EXPOSE 80

CMD ["php", "artisan", "octane:frankenphp", "--host=0.0.0.0", "--port=80"]
