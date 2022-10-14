ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION} as downloader

ARG HELM_VERSION
ARG KUBECTL_VERSION
ARG HELMFILE_VERSION
ARG KUSTOMIZE_VERSION

# This is a builder image, we do not need cache maintenance here
# hadolint ignore=DL3019
RUN apk add curl
WORKDIR /downloader
RUN curl https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar xz --strip-components 1 linux-amd64/helm
RUN curl -L -o kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
RUN curl -L https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz | tar xz helmfile
RUN curl -L https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz | tar xz
RUN chmod +x /downloader/*

# The actual toolbox image
FROM alpine:${ALPINE_VERSION}

ARG S3CMD_VERSION
ARG HELMDIFF_VERSION

COPY --from=downloader /downloader/* /usr/bin/
RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk --update add --no-cache git bash curl make openssh openssl coreutils pv "s3cmd@testing=${S3CMD_VERSION}" \
  && helm plugin install https://github.com/databus23/helm-diff --version "${HELMDIFF_VERSION}" \
  && helm plugin install https://github.com/aslafy-z/helm-git --version "${HELMGIT_VERSION}" \
  && helm repo add stable https://charts.helm.sh/stable
