#!/bin/bash

# Handle the IP change
cat /etc/hosts | grep -v "inchoo.host.internal" > /etc/hosts
echo "`/sbin/ip route|awk '/default/ { print $3 }' | grep -v ppp` inchoo.host.internal" | tee -a /etc/hosts > /dev/null

# Fallback for certificaiton URL
if [[ -z "${CERTIFICATION_URL}" ]]; then
  CERTIFICATION_URL="default"
fi
mkdir -p /etc/apache2/ssl
if [ ! -f /etc/apache2/ssl/${CERTIFICATION_URL}.cert ]; then
    openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=${CERTIFICATION_URL}" -keyout /etc/apache2/ssl/${CERTIFICATION_URL}.key  -out /etc/apache2/ssl/${CERTIFICATION_URL}.cert
fi

# Setup Apache document root
sed "s#DOCUMENT_ROOT#${DOCUMENT_ROOT:-/var/www/html}#g" -i /etc/apache2/sites-available/000-default.conf
sed "s#CERTIFICATION_URL#${CERTIFICATION_URL:-default}#g" -i /etc/apache2/sites-available/000-default.conf

# Fix link-count, as cron is being a pain, and docker is making hardlink count >0 (very high)
touch /etc/crontab /etc/cron.*/*

# Run services
service ssh start
service cron start
service php7.4-fpm start
/usr/sbin/apache2ctl -D FOREGROUND
