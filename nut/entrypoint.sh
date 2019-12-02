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

ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

chmod 644 /etc/nut/*.html
chown www-data:www-data /usr/lib/cgi-bin/nut/*.cgi

chmod 755 /etc/nut/notifycmd.sh

msmtp_config
touch /var/log/msmtp.log
touch /var/log/twilio.log

upsdrvctl -D -u root start
upsd -u root
upsmon -u root
upslog -s CyberPower-1400VA@localhost -l /var/log/ups.log

#fcgiwrap -s unix:/var/run/fcgiwrap.socket &
service fcgiwrap restart
#nginx -g 'daemon off;'
service nginx restart

tail -f /var/log/nginx/* /var/log/ups.log /var/log/msmtp.log /var/log/twilio.log