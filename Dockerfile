FROM codacy/ci-base:1.0.1

LABEL maintainer="Codacy <team@codacy.com>"

ENV TERRAFORM_VERSION=0.11.13
ENV HELM_VERSION=v2.13.0
ENV HELM_SSM_VERSION=1.0.2
ENV KUBECTL_VERSION=v1.13.4
ENV DOCTL_VERSION=1.18.0

ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip ./
ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS ./

RUN sed -i '/.*linux_amd64.zip/!d' terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sha256sum -cs terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
    curl -L "https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz" | tar -zxf - && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    helm init --client-only && \
    helm plugin install https://github.com/codacy/helm-ssm/releases/download/${HELM_SSM_VERSION}/helm-ssm-linux.tgz && \
    helm plugin install https://github.com/chartmuseum/helm-push && \
    curl -Lo /usr/local/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x /usr/local/bin/kubectl && \
    curl -sL https://github.com/digitalocean/doctl/releases/download/v${DOCTL_VERSION}/doctl-${DOCTL_VERSION}-linux-amd64.tar.gz | tar -xzv && \
    mv doctl /usr/local/bin && \
    chmod +x /usr/local/bin/doctl && \
    chown -R root:root /usr/local/bin/ &&\
    rm -rf *
