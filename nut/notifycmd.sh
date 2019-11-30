#!/bin/bash
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

printf "To: $ALERT_EMAIL_TO\n\
From: $ALERT_EMAIL_FROM_NAME\ <$ALERT_EMAIL_FROM>\n\
Subject: $NOTIFYTYPE Battery Alert!\n\n\
UPS: $UPSNAME\r\n\
Alert type: $NOTIFYTYPE" | \
msmtp -C /.msmtprc \
	--logfile=/var/log/msmtp.log -dS $ALERT_EMAIL_TO

# Kubernetes should map a ConfigMap to .msmtprc file and consumed by `msmtp -C .msmtprc` instead of the above.

# --auth=on --tls=on --tls-certcheck=on --tls-trust-file=/etc/ssl/certs/ca-certificates.crt\
# 	--host=$SMTP_HOST --protocol=smtp --port=$SMTP_PORT --user=$SMTP_USER  \
# 	--from=$ALERT_EMAIL_FROM \