#!/bin/bash

set -e

helm lint $(pwd)/../../helm/ups-mon/.

# seems to be a bug preventing "docker build -t nut-server:test -f Dockerfile.debian $(pwd)/../../nut/."
# so change dirs instead
cd ../../nut
docker build -t abarruda/nut-server:test -f Dockerfile.debian .
cd -
docker build -t abarruda/nut-rest-api:test $(pwd)/../../rest-api/.

k3d cluster create --config k3d.yaml || true
# k3d labelling seems to only apply to the docker container, not the kubernetes node
kubectl label node k3d-ups-mon-cluster-server-0 ups=enabled || true

k3d image import -c ups-mon-cluster abarruda/nut-server:test
k3d image import -c ups-mon-cluster abarruda/nut-rest-api:test

helm template ups-mon-test \
	--debug \
	--set service.port=8081 \
	--set config.ups.name="CP1500PFCLCD-mock" \
	--set config.ups.fullName="Mock UPS" \
	--set config.ups.location=localhost \
	--set config."ups\.conf".driver=dummy-ups \
	--set config."ups\.conf".port=/etc/nut/mock-ups.dev \
	--set config."upsd\.users".admin.name=admin \
	--set config."upsd\.users".admin.password=admin \
	--set config."upsd\.users".user.name=upsmon_local \
	--set config."upsd\.users".user.password=local1 \
	--set secrets.alert.emailTo=some@email.com \
	--set secrets.alert.emailFrom=some@email.com \
	--set secrets.alert.emailFromName="Battery Alert" \
	--set secrets.alert.smtp.host=some.host.com \
	--set secrets.alert.smtp.port=\"26\" \
	--set secrets.alert.smtp.user=alerts@email.com \
	--set secrets.alert.smtp.password=pass \
	--set secrets.alert.twilio.account=test \
	--set secrets.alert.twilio.authToken=1C \
	--set secrets.alert.twilio.fromNumber=\"+11234567890\" \
	--set secrets.alert.twilio.toNumber=\"+11234567890\" \
	--set nodeSelector.ups=enabled \
	--set test.enabled=true \
	../../helm/ups-mon

helm upgrade ups-mon-test \
    --install \
	--debug \
	--set service.port=8081 \
	--set config.ups.name="CP1500PFCLCD-mock" \
	--set config.ups.fullName="Mock UPS" \
	--set config.ups.location=localhost \
	--set config."ups\.conf".driver=dummy-ups \
	--set config."ups\.conf".port=/etc/nut/mock-ups.dev \
	--set config."upsd\.users".admin.name=admin \
	--set config."upsd\.users".admin.password=admin \
	--set config."upsd\.users".user.name=upsmon_local \
	--set config."upsd\.users".user.password=local1 \
	--set secrets.alert.emailTo=some@email.com \
	--set secrets.alert.emailFrom=some@email.com \
	--set secrets.alert.emailFromName="Battery Alert" \
	--set secrets.alert.smtp.host=some.host.com \
	--set secrets.alert.smtp.port=\"26\" \
	--set secrets.alert.smtp.user=alerts@email.com \
	--set secrets.alert.smtp.password=pass \
	--set secrets.alert.twilio.account=test \
	--set secrets.alert.twilio.authToken=1C \
	--set secrets.alert.twilio.fromNumber=\"+11234567890\" \
	--set secrets.alert.twilio.toNumber=\"+11234567890\" \
	--set nodeSelector.ups=enabled \
	--set test.enabled=true \
	../../helm/ups-mon

kubectl wait --for=condition=available --timeout=600s deployment/ups-mon-deployment
kubectl port-forward service/ups-mon-service 8080 8081

# http://localhost:8080/jnut/nut/servers/localhost/CP1500PFCLCD-mock/vars
# http://localhost:8080/jnut/nut/servers/localhost/CP1500PFCLCD-mock/vars/battery.runtime

# k3d cluster delete ups-mon-cluster