#! /bin/sh -e

cp /tmp/hosts.conf /etc/nut/hosts.conf
chmod 644 /etc/nut/hosts.conf
chmod 644 /etc/nut/*.html
chown www-data:www-data /usr/lib/cgi-bin/nut/*.cgi

cp /tmp/notifycmd.sh /etc/nut/notifycmd.sh
chmod 755 /etc/nut/notifycmd.sh

upsdrvctl -D -u root start
upsd -u root
upsmon -u root

upslog -s CyberPower-1400VA@localhost -l /var/log/ups.log

service fcgiwrap restart
service nginx restart

touch /var/log/msmtp.log

tail -f /var/log/nginx/* /var/log/ups.log /var/log/msmtp.log