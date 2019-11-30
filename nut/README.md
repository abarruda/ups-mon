## Build

*Note: Web monitoring is only supported in Debian build*

```
docker build -t ups-nut:test -f Dockerfile.debian
```

## Run
For real time web based monitoring on port 8888 and email based alerting:

- Required environment variables in environment file (referenced by *run.sh* as *test/env.file*): 

		ALERT_EMAIL_TO
		ALERT_EMAIL_FROM
		ALERT_EMAIL_FROM_NAME
		SMTP_HOST
		SMTP_PORT
		SMTP_USER
		SMTP_PASS

- Start:

		./run.sh

