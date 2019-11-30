docker run -it \
	--name ups-mon \
	--rm \
	--privileged \
	-v $(pwd)/config/ups.conf:/etc/nut/ups.conf \
	-v $(pwd)/config/upsd.conf:/etc/nut/upsd.conf \
	-v $(pwd)/config/upsd.users:/etc/nut/upsd.users \
	-v $(pwd)/config/upsmon.conf:/etc/nut/upsmon.conf \
	-v $(pwd)/config/nut.conf:/etc/nut/nut.conf \
	-v $(pwd)/config/hosts.conf:/tmp/hosts.conf \
	-v $(pwd)/test/CP1500PFCLCD.dev:/etc/nut/CP1500PFCLCD.dev \
	-p 8888:80 \
	--env-file ./test/env.file \
	ups-nut:test