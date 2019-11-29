docker run -it \
	--name ups-mon \
	--rm \
	--privileged \
	-v $(pwd)/ups.conf:/etc/nut/ups.conf \
	-v $(pwd)/upsd.conf:/etc/nut/upsd.conf \
	-v $(pwd)/upsd.users:/etc/nut/upsd.users \
	-v $(pwd)/upsmon.conf:/etc/nut/upsmon.conf \
	-v $(pwd)/nut.conf:/etc/nut/nut.conf \
	-v $(pwd)/hosts.conf:/tmp/hosts.conf \
	-v $(pwd)/nginx.conf:/etc/nginx/sites-available/default \
	-v $(pwd)/test/CP1500PFCLCD.dev:/etc/nut/CP1500PFCLCD.dev \
	-p 8888:80 \
	ups-nut:test