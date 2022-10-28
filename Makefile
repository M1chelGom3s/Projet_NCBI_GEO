build:
	sudo docker build -f bin/Dockerfile -t app_get_geo .
run:
	mkdir data
	sudo docker run -d -t -i -v $(pwd)/data:/project_GEO app_get_geo /bin/bash
	sudo docker exec -it $(sudo docker container ls  | grep 'app_get_geo' | awk '{print $1}') /bin/bash

all: build run