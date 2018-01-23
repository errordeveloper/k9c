build_image:
	docker build --tag errordeveloper/k9c:latest ./build

push_image: build_image
	docker push errordeveloper/k9c:latest
