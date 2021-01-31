CC=docker
TEST_CMD=go test /go/medtech/src/...

IMAGE_NAME=medtech
DEV_CONTAINER=medtech-dev
TEST_CONTAINER=medtech-test

SSH_PRIVATE_KEY=`cat ~/.ssh/id_rsa`
SSH_PUBLIC_KEY=`cat ~/.ssh/id_rsa.pub`
OTHER_KEYS=./keys

# Build docker image
build_image: Dockerfile
	$(CC) build \
		--build-arg SSH_PRIVATE_KEY="${SSH_PRIVATE_KEY}" \
		--build-arg SSH_PUBLIC_KEY="${SSH_PUBLIC_KEY}" \
		-t $(IMAGE_NAME) .

# Run all the tests in the container
test:
	@$(CC) run -d -it --name=$(TEST_CONTAINER) -dp 3000:3000 $(IMAGE_NAME)
	@$(CC) exec -it $(TEST_CONTAINER) $(TEST_CMD)
	@$(CC) stop $(TEST_CONTAINER)
	@$(CC) rm $(TEST_CONTAINER)

# Start the server in the container
run:
	$(CC) run -d --name=$(DEV_CONTAINER) -dp 3000:3000 $(IMAGE_NAME)
	$(CC) attach $(DEV_CONTAINER)

clean_image:
	$(CC) rmi $(IMAGE_NAME)

# Clean the container and the image
clean:
	$(CC) stop $(DEV_CONTAINER)
	$(CC) rm $(DEV_CONTAINER)
	$(MAKE) clean_image
