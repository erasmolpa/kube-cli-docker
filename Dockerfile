FROM debian:buster-slim
LABEL maintainer "erasmolpa <erasmolpa@gmail.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian" \
    OS_NAME="linux"

ARG BUILD_DATE

ARG KUBECTL_VERSION=1.18.9

ARG HELM_VERSION=3.5.0

ARG HELM_DIFF_VERSION=3.1.3
ARG HELM_SECRETS_VERSION=2.0.2
ARG HELM_GIT_VERSION=0.10.0
ARG HELM_2to3_VERSION=0.8.2
ARG HELM_BACKUP_VERSION=0.1.3
ARG HELM_MONITOR_VERSION=0.4.0

ARG HELMFILE_VERSION=0.138.7

WORKDIR /

# Metadata
LABEL org.label-schema.name="kube-cli-docker" \
      org.label-schema.url="https://hub.docker.com/r/erasmolpa/kube-cli-docker/" \
      org.label-schema.vcs-url="https://github.com/erasmolpa/kube-cli-docker" \
      org.label-schema.build-date=$BUILD_DATE

RUN apt-get update && \
    apt-get install -y vim git gnupg curl gettext jq procps tar wget unzip sudo python3-pip

ADD https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl
RUN kubectl version --client

RUN mkdir .kube/

ADD https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz /tmp
RUN tar -zxvf /tmp/helm* -C /tmp \
  && mv /tmp/linux-amd64/helm /bin/helm \
  && rm -rf /tmp/*

RUN helm version

ADD https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64 /bin/helmfile
RUN chmod 0755 /bin/helmfile
RUN helmfile version


RUN helm plugin install https://github.com/databus23/helm-diff --version ${HELM_DIFF_VERSION} && \
    helm plugin install https://github.com/futuresimple/helm-secrets --version ${HELM_SECRETS_VERSION} && \
    helm plugin install https://github.com/helm/helm-2to3.git --version ${HELM_2to3_VERSION}  && \
    helm plugin install https://github.com/maorfr/helm-backup --version ${HELM_BACKUP_VERSION} && \
    helm plugin install https://github.com/ContainerSolutions/helm-monitor --version ${HELM_MONITOR_VERSION} && \
    helm plugin install https://github.com/aslafy-z/helm-git --version  ${HELM_GIT_VERSION} && \
    helm repo add "stable" "https://charts.helm.sh/stable" --force-update

CMD bash
