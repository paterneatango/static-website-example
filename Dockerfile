FROM ubuntu
LABEL org.opencontainers.image.authors="Paterne"

# Installation serveur NGINX
RUN apt-get update
RUN apt install -y nginx

# Création variable environnement PORT
ENV PORT=80

# Suppression des fichiers de config par défaut
RUN rm -R /etc/nginx/sites-available/*

# Suppression des fichiers par défaut à la racine du serveur
RUN rm -R /var/www/html/*

# Copie du site web à la racine du serveur NGINX
COPY ./website/ /var/www/html/

# Ajout d'un nouveau fichier de config comprenant la variable d'environnement $PORT
COPY default /etc/nginx/sites-available/

# Lancement => Insertion de la variable d'environnement $PORT dans le fichier de config et Exécution de NGINX
CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/sites-available/default && nginx -g 'daemon off;'