FROM codacy/ci-base:1.0.1

LABEL maintainer="Codacy <team@codacy.com>"

ENV TERRAFORM_VERSION=0.12.24
ENV HELM_VERSION=v3.2.1
ENV HELM_SSM_VERSION=1.0.3
ENV KUBECTL_VERSION=v1.16.2
ENV DOCTL_VERSION=1.33.1
ENV PYTHON3_VERSION=3.6.9-r1
ENV PIP_VERSION=19.3.1
ENV SETUPTOOLS_VERSION=41.4.0

COPY requirements.pip .

ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip ./
ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS ./

RUN apk add --no-cache python3==${PYTHON3_VERSION} && \
    pip3 install --upgrade pip==${PIP_VERSION} setuptools==${SETUPTOOLS_VERSION} && \
    pip3 --no-cache-dir install -r requirements.pip && \
    sed -i '/.*linux_amd64.zip/!d' terraform_${TERRAFORM_VERSION}_SHA256SUMS
RUN sed -i '/.*linux_amd64.zip/!d' terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sha256sum -cs terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
    curl -L "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" | tar -zxf - && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    helm plugin install https://github.com/codacy/helm-ssm/releases/download/${HELM_SSM_VERSION}/helm-ssm-linux.tgz && \
    helm plugin install https://github.com/chartmuseum/helm-push && \
    helm plugin install https://github.com/codacy/helm-poll/releases/download/latest/helm-poll-linux.tgz && \
    helm repo add codacy-stable https://charts.codacy.com/stable/ && \
    curl -Lo /usr/local/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x /usr/local/bin/kubectl && \
    curl -sL https://github.com/digitalocean/doctl/releases/download/v${DOCTL_VERSION}/doctl-${DOCTL_VERSION}-linux-amd64.tar.gz | tar -xzv && \
    apk add --no-cache libc6-compat && \
    mv doctl /usr/local/bin && \
    chmod +x /usr/local/bin/doctl && \
    wget -q -O /usr/bin/yq $(wget -q -O - https://api.github.com/repos/mikefarah/yq/releases/latest | jq -r '.assets[] | select(.name == "yq_linux_amd64") | .browser_download_url') &&\
    chmod +x /usr/bin/yq &&\
    chown -R root:root /usr/local/bin/ &&\
    rm -rf ./*
