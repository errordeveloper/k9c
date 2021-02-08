build_image:
	docker build --tag idiotoflinux/k9c:latest ./build

push_image: build_image
	docker push idiotoflinux/k9c:latest

generate_public_manifests: ide.yaml traefik.yaml

%.yaml:
	./kubegen module ./modules/$$(basename $@ .yaml) -s \
	  | /usr/local/bin/kubectl convert -f - > manifests/$@
