docker run -it \
	--rm \
	--privileged \
	-v $(pwd)/ups.conf:/etc/nut/ups.conf \
	-v $(pwd)/upsd.conf:/etc/nut/upsd.conf \
	-v $(pwd)/upsd.users:/etc/nut/upsd.users \
	-v $(pwd)/upsmon.conf:/etc/nut/upsmon.conf \
	-v $(pwd)/nut.conf:/etc/nut/nut.conf \
	-v $(pwd)/test/CP1500PFCLCD.dev:/etc/nut/CP1500PFCLCD.dev \
	--device=/dev/ttyUSB0 \
	ups-nut:test \
	/bin/sh