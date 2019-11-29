#! /bin/sh -e

cp /tmp/hosts.conf /etc/nut/hosts.conf
chmod 644 /etc/nut/hosts.conf
chmod 644 /etc/nut/*.html
chown www-data:www-data /usr/lib/cgi-bin/nut/*.cgi

upsdrvctl -D -u root start
upsd -u root

service fcgiwrap restart
service nginx restart

tail -f /var/log/nginx/*