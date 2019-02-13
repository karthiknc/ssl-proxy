FROM alpine:3.8

ENV SSL_PORT=443

RUN apk add --no-cache nginx openssl gettext

ADD add_self_signed_certs.sh nginx.conf.template configure_nginx.sh v3.ext /

EXPOSE ${SSL_PORT}

ENTRYPOINT ["/configure_nginx.sh"]
