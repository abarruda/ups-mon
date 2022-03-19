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
