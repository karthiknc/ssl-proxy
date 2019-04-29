#!/bin/sh -e

DOMAIN=${DOMAIN:-www.example.com}
CERT_DIR=/etc/nginx/certs
V3_DIR=/etc/nginx/certs/

if [ ! -f ${CERT_DIR}/v3.ext ]; then
	V3_DIR=/
fi

mkdir -p $CERT_DIR

# Generate the root CA if it doesn't exist
if [ ! -f ${CERT_DIR}/rootCA.crt ]; then
	openssl genrsa -out ${CERT_DIR}/rootCA.key 2048
	openssl req -x509 -new -nodes -key ${CERT_DIR}/rootCA.key -sha256 -days 3650 -subj "/C=IN/ST=Bengaluru/L=ECity/O=News/CN=ecslocal" -out ${CERT_DIR}/rootCA.crt
fi

if [ ! -f ${CERT_DIR}/key.pem ]; then
    # Generate the certificate
    openssl genrsa -out ${CERT_DIR}/key.pem 2048
    openssl req -new -sha256 -key ${CERT_DIR}/key.pem -nodes -subj "/C=IN/ST=Bengaluru/L=ECity/O=NTS/CN=${DOMAIN}" -out ${CERT_DIR}/csr.pem
    openssl x509 -req -in ${CERT_DIR}/csr.pem -CA ${CERT_DIR}/rootCA.crt -CAkey ${CERT_DIR}/rootCA.key -CAcreateserial -out ${CERT_DIR}/cert.pem -sha256 -extfile ${V3_DIR}v3.ext -days 3650
fi
