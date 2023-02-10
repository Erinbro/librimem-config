#!/usr/bin/bash

openssl req -newkey rsa:4096 \
    -x509 \
    -sha256 \
    -days 66 \
    -nodes \
    -out tls.crt \
    -keyout tls.key \
    -subj "/CN=librimem.com/0=librimem.com"
