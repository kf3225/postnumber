FROM nginx:1.19-alpine

WORKDIR /etc/nginx/conf.d
ADD ./conf.d/default.conf .

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
