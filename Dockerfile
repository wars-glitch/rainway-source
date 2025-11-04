# 1️⃣ Imagem base com PHP e Apache
FROM php:8.2-apache

# 2️⃣ Diretório de trabalho
WORKDIR /var/www/html

# 3️⃣ Instalar dependências do sistema e extensões PHP necessárias
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl bcmath sockets \
    && docker-php-source delete

# 4️⃣ Habilitar mod_rewrite do Apache
RUN a2enmod rewrite

# 5️⃣ Instalar Composer globalmente
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 6️⃣ Copiar arquivos do projeto
COPY . .

# 7️⃣ Instalar dependências PHP do projeto
RUN composer install --no-dev --optimize-autoloader

# 8️⃣ Expor porta 80
EXPOSE 80

# 9️⃣ Comando padrão
CMD ["apache2-foreground"]
