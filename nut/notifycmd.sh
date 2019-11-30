#!/bin/bash

set -x

battery=`upsc CyberPower-1400VA@localhost battery.charge`
runtime_seconds=`upsc CyberPower-1400VA@localhost battery.runtime`
runtime_minutes=$(expr $runtime_seconds / 60)
load=`upsc CyberPower-1400VA@localhost ups.load`

curl "https://api.twilio.com/2010-04-01/Accounts/$TWILIO_ACCOUNT/Messages.json" -X POST \
--data-urlencode "To=$TWILIO_TO_NUMBER" \
--data-urlencode "From=$TWILIO_FROM_NUMBER" \
--data-urlencode "Body=$NOTIFYTYPE Battery Alert! 

$1

Battery: $battery%
Runtime: $runtime_minutes minutes
Load: $load%

UPS: $UPSNAME 
Alert type: $NOTIFYTYPE" \
-u $TWILIO_ACCOUNT:$TWILIO_AUTH_TOKEN >> /var/log/twilio.log

printf "To: $ALERT_EMAIL_TO\n\
From: $ALERT_EMAIL_FROM_NAME\ <$ALERT_EMAIL_FROM>\n\
Subject: $NOTIFYTYPE Battery Alert!\n\n\
$1\n\n\
Battery: $battery%%\n\
Runtime: $runtime_minutes minutes\n\
Load: $load%%\n\n\
UPS: $UPSNAME\r\n\
Alert type: $NOTIFYTYPE" | \
msmtp -C /.msmtprc \
	--logfile=/var/log/msmtp.log -dS $ALERT_EMAIL_TO >> /var/log/msmtp.log

# Kubernetes should map a ConfigMap to .msmtprc file and consumed by `msmtp -C .msmtprc` instead of the above.
