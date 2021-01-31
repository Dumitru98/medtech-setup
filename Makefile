CC=docker
TEST_CMD=go test /go/medtech/src/...

IMAGE_DEV_NAME=medtech-dev-img
IMAGE_TEST_NAME=medtech-test-img
DEV_CONTAINER=medtech-dev
TEST_CONTAINER=medtech-test

SSH_PRIVATE_KEY=`cat /home/calin/.ssh/id_rsa`
SSH_PUBLIC_KEY=`cat /home/calin/.ssh/id_rsa.pub`

# Build docker image
build-image:
	$(CC) build \
		--build-arg SSH_PRIVATE_KEY="${SSH_PRIVATE_KEY}" \
		--build-arg SSH_PUBLIC_KEY="${SSH_PUBLIC_KEY}" \
		-t $(IMAGE_DEV_NAME) .

# Clean the image
clean-image:
	$(CC) rmi $(IMAGE_DEV_NAME)

# Clean the container and the image
clean:
	-$(CC) stop $(DEV_CONTAINER)
	$(CC) rm $(DEV_CONTAINER)

# Start the server in the container
run:
	$(CC) run -d --name=$(DEV_CONTAINER) -dp 3000:3000 $(IMAGE_DEV_NAME)
	$(CC) attach $(DEV_CONTAINER)

# Run all the tests in the container
.ONESHELL:

test:
	@$(CC) build \
		--build-arg SSH_PRIVATE_KEY="${SSH_PRIVATE_KEY}" \
		--build-arg SSH_PUBLIC_KEY="${SSH_PUBLIC_KEY}" \
		-t $(IMAGE_TEST_NAME) .
	@$(CC) run -d -it --name=$(TEST_CONTAINER) -dp 3000:3000 $(IMAGE_TEST_NAME)
	@$(CC) exec $(TEST_CONTAINER) $(TEST_CMD)
	@EXIT_CODE=$$?
	@$(CC) stop $(TEST_CONTAINER)
	@$(CC) rm $(TEST_CONTAINER)
	@$(CC) rmi $(IMAGE_TEST_NAME)
	@exit $$EXIT_CODE
