#!/bin/bash

docker run -it \
	--name jnut-rest \
	--rm \
	--privileged \
	-v $(pwd)/../nut/config/hosts-test.conf:/etc/nut/hosts.conf \
	-v $(pwd)/../nut/config/nut.conf:/etc/nut/nut.conf \
	-v $(pwd)/../nut/config/ups-test.conf:/etc/nut/ups.conf \
	-v $(pwd)/../nut/config/upsd.conf:/etc/nut/upsd.conf \
	-v $(pwd)/../nut/config/upsd.users:/etc/nut/upsd.users \
	-v $(pwd)/../nut/config/upsmon-test.conf:/etc/nut/upsmon.conf \
	-v $(pwd)/../nut/test/CP1500PFCLCD.dev:/etc/nut/mock-ups.dev \
	-p 8081:8080 \
	abarruda/nut-rest-api:test
