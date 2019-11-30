#! /bin/sh -e

msmtp_config()
{
	echo "# Accounts will inherit settings from this section
defaults
auth            on
tls             on
tls_certcheck   on
tls_trust_file  /etc/ssl/certs/ca-certificates.crt

account   default 
host      $SMTP_HOST
protocol  smtp
port      $SMTP_PORT
from      $SMTP_USER
user      $SMTP_USER
password  $SMTP_PASS" > /.msmtprc
}

cp /tmp/hosts.conf /etc/nut/hosts.conf
chmod 644 /etc/nut/hosts.conf
chmod 644 /etc/nut/*.html
chown www-data:www-data /usr/lib/cgi-bin/nut/*.cgi

cp /tmp/notifycmd.sh /etc/nut/notifycmd.sh
chmod 755 /etc/nut/notifycmd.sh

msmtp_config
touch /var/log/msmtp.log

upsdrvctl -D -u root start
upsd -u root
upsmon -u root
upslog -s CyberPower-1400VA@localhost -l /var/log/ups.log

service fcgiwrap restart
service nginx restart

tail -f /var/log/nginx/* /var/log/ups.log /var/log/msmtp.log