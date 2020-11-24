ARG BASE_CONTAINER=python:3.7-buster
ARG IMAGE_TYPE=plain

FROM ${BASE_CONTAINER} 

RUN apt update
RUN apt install software-properties-common -y

# Install packages
RUN apt-get install libssl-dev libcurl4-openssl-dev  -y

COPY . /example
WORKDIR /example
RUN python3.7 -m pip install --upgrade setuptools

RUN python3.7 -V
RUN python3.7 -m pip install -r requirements.txt --no-cache-dir

RUN chmod +x /app/entry.sh
ENTRYPOINT [ "/app/entry.sh" ]
