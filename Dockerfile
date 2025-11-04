# Etapa 1: Instalar dependências Laravel
FROM composer:2 AS build
WORKDIR /app
COPY . .
RUN composer install --no-dev --optimize-autoloader

# Etapa 2: Servidor PHP + Apache
FROM php:8.2-apache
WORKDIR /var/www/html
COPY --from=build /app /var/www/html

# Instalar extensões necessárias do PHP
RUN docker-php-ext-install pdo pdo_mysql

# Permissões corretas para Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80
CMD ["apache2-foreground"]
