FROM golang:latest

 # Get python
 RUN apt-get update
 RUN apt-get -y install python3

 # Get medtech repository
 ARG SSH_PRIVATE_KEY
 ARG SSH_PUBLIC_KEY

 RUN mkdir -p /root/.ssh && \
     chmod 0700 /root/.ssh && \
     ssh-keyscan github.com > /root/.ssh/known_hosts

 RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa && \
     echo "${SSH_PUBLIC_KEY}" > /root/.ssh/id_rsa.pub && \
     chmod 600 /root/.ssh/id_rsa && \
     chmod 600 /root/.ssh/id_rsa.pub

 RUN git clone git@github.com:Dumitru98/medtech

 # Build app and get keys
 WORKDIR /go/medtech/src
 RUN make build

 # Server setup
 EXPOSE 3000