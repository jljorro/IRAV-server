FROM ubuntu:latest

## Actualizamos la imagen
RUN apt update
RUN apt install -y supervisor

COPY ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# [APACHE SERVER]
## Instalamos Apache
RUN apt install -y apache2 apache2-utils

# [Habilitamos el módulo de Proxy]
RUN a2enmod proxy_http

## Copiamos dentro de la imagen los ficheros de configuración de apache
## (Esto se hace antes de arrancar el servicio para que se apliquen los cambios)
COPY ./config/apache/sites-available/web1.conf /etc/apache2/sites-available/web1.conf
COPY ./config/apache/sites-available/web2.conf /etc/apache2/sites-available/web2.conf
COPY ./config/apache/sites-available/node-api.com.conf /etc/apache2/sites-available/node-api.com.conf

# [Configuramos los puertos de apache]
COPY ./config/apache/ports.conf /etc/apache2/ports.conf

# [Desactivamos el sitio web por defecto]
RUN a2dissite 000-default

# [Agregar los sitios web]
RUN a2ensite web1
RUN a2ensite web2
RUN a2ensite node-api.com

# [NODEJS]
## Instalamos nodejs
RUN apt install -y nodejs npm

# Aplicamos el directorio de trabajo
WORKDIR /var/www/sites/node-api.com
COPY ./sites/node-api.com/* .

## Abrimos los puertos de nuestro servidor (Apache y Nodejs)
EXPOSE 80
EXPOSE 81
EXPOSE 82
#EXPOSE 3000

# Arrancamos apache en Background
# CMD ["./usr/local/home/start-server.sh"]
# CMD ["apachectl", "-D", "FOREGROUND"]
CMD ["/usr/bin/supervisord"]