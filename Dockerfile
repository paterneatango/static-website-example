FROM nginx:1.21.1
LABEL maintainer="Paterne Arthur"
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl && \
    apt-get install -y git
RUN rm -Rf /usr/share/nginx/html/*
RUN git clone https://github.com/Athuro04/static-website-example.git /usr/share/nginx/html
#COPY nginx.conf  /etc/nginx/conf.d/default.conf
CMD ["nginx", "-g", "daemon off;"]