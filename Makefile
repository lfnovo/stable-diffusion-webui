


build:
	docker build -f Dockerfile -t sd-webui:bullseye . 

tag:
	docker tag sd-webui:bullseye registry.homelab:5000/sd-webui:bullseye  

push:  build tag
	docker push registry.homelab:5000/sd-webui:bullseye