FROM nginx

COPY app /usr/share/nginx/html

COPY nginx.conf /etc/nginx/

EXPOSE 8080