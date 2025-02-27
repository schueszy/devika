FROM debian:12

# setting up os env
USER root
WORKDIR /home/nonroot/client
RUN groupadd -r nonroot && useradd -r -g nonroot -d /home/nonroot/client -s /bin/bash nonroot

# install node js 
RUN apt-get update && apt-get upgrade
RUN apt-get install -y build-essential software-properties-common curl sudo wget git
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
RUN apt-get install nodejs

# copying devika app client only
COPY ui /home/nonroot/client/ui
COPY src /home/nonroot/client/src
COPY config.toml /home/nonroot/client/

RUN cd ui && npm install && npm upgrade -g npm
RUN chown -R nonroot:nonroot /home/nonroot/client

USER nonroot
WORKDIR /home/nonroot/client/ui

ENTRYPOINT [ "npm", "run", "dev", "--", "--host" ]