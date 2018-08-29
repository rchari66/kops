FROM alpine:3.8

MAINTAINER raghav0966@gmail.com

RUN echo "https://mirror.csclub.uwaterloo.ca/alpine/v3.7/main" >/etc/apk/repositories && echo "https://mirror.csclub.uwaterloo.ca/alpine/v3.7/community" >>/etc/apk/repositories

RUN apk update && \
    apk upgrade && \
    apk add curl && apk add bash && apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && pip install awscli && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

# COPY kops ./

RUN curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64 &&\
	chmod +x kops-linux-amd64 && mv kops-linux-amd64 /usr/local/bin/kops

# install kubectl
RUN wget -O kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
	&& chmod +x ./kubectl \
	&& mv ./kubectl /usr/local/bin/kubectl

# install helm(package manager for kubernetes)
COPY helm-v2.10.0-arm64.tar.gz /tmp/
RUN cd /tmp && tar -zxvf helm-v2.10.0-arm64.tar.gz && mv linux-arm64/helm /usr/local/bin/helm

CMD ["/bin/bash"]
# RUN chmod +x ./kops && mv ./kops /usr/local/bin/ 


