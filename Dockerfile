FROM alpine:3.11

ARG TERRAFORM_VERSION=0.12.25

RUN set -eux \
  && apk update\
  && apk add --no-cache curl bash\
  && curl -fSL -o terraform.zip  https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && mkdir -p /terraform/bin \
  && unzip terraform.zip -d /terraform/bin \
  && rm terraform.zip

ENV PATH /terraform/bin:$PATH

WORKDIR /data

CMD ["/bin/bash"]
