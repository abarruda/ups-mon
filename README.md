# ups-mon
NUT based UPS monitoring for Kubernetes.  

Components:
- NUT server providing alerting and graphical interface via USB communication with UPS
- NUT REST API

# Running / Developing Locally

Requirements:
- docker
- k3d

[Convenience script](test/k8s/k3d-run.sh) to lint helm chart, build container images, create k3d Kubernetes cluster, and deploy `ups-mon` helm chart using a mock battery configuration.

# Building Images for Raspberry Pi

```bash
docker build --platform linux/arm/v7  -t nut-server:0.2.0-arm32v7 -f Dockerfile.debian .

docker build --platform linux/arm/v7  -t nut-rest-api:0.2.0-arm32v7 -f Dockerfile.arm32v7 .
```

# Testing
To test alerting via email and Twilio integration: 

```bash
% kubectl exec -it ups-mon-5cc9dddf59-plkdf -c nut-server /bin/bash
root@ups-mon-5cc9dddf59-plkdf:/# ps -ef | grep upsd
root        35     1  0 20:08 ?        00:00:00 /lib/nut/upsd -u root
root        96    88  0 20:09 pts/0    00:00:00 grep upsd
root@ups-mon-5cc9dddf59-plkdf:/# kill 35
```

Killing the `upsd` process will terminate the connection between the nut server and the UPS.  This will invoke a `COMMBAD` notify event to send an email and SMS alert message.  This liveness probe will now fail and trigger a restart of the Pod.
