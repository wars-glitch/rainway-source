# Use uma imagem oficial do PHP com Apache
FROM php:8.2-apache

# Defina diretório de trabalho
WORKDIR /var/www/html

# Instale dependências do sistema e extensões PHP necessárias
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl bcmath sockets \
    && docker-php-source delete

# Habilite o mod_rewrite do Apache (necessário para muitos frameworks)
RUN a2enmod rewrite

# Instale Composer globalmente
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copie os arquivos do projeto para o container
COPY . .

# Instale dependências do PHP sem os dev e otimizando autoload
RUN composer install --no-dev --optimize-autoloader

# Exponha a porta padrão do Apache
EXPOSE 80

# Comando padrão ao iniciar o container
CMD ["apache2-foreground"]
