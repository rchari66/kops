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

# ADD credentials /root/.aws/credentials

# COPY kops ./

RUN curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64 &&\
	chmod +x kops-linux-amd64 && mv kops-linux-amd64 /usr/local/bin/kops
# RUN chmod +x ./kops && mv ./kops /usr/local/bin/ 


