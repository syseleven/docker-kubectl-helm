ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION} as downloader

ARG HELM_VERSION
ARG KUBECTL_VERSION
ARG HELMFILE_VERSION
ARG KUSTOMIZE_VERSION

# This is a builder image, we do not need cache maintenance here
# hadolint ignore=DL3019
RUN apk add curl
RUN curl https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar xz
RUN curl -L -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
RUN curl -L -o /usr/bin/helmfile https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64
RUN curl -L https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz | tar xz
RUN chmod +x /usr/bin/kubectl linux-amd64/* /usr/bin/helmfile

# The actual toolbox image
FROM alpine:${ALPINE_VERSION}

ARG S3CMD_VERSION
ARG HELMDIFF_VERSION

COPY --from=downloader /usr/bin/kubectl /usr/bin/kubectl
COPY --from=downloader linux-amd64/helm /usr/bin/helm
RUN apk add git openssh --no-cache
RUN helm plugin install https://github.com/aslafy-z/helm-git
COPY --from=downloader /usr/bin/helmfile /usr/bin/helmfile
COPY --from=downloader kustomize /usr/bin/kustomize
RUN echo ${S3CMD_VERSION}
RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk --update add --no-cache git bash curl make openssl coreutils pv "s3cmd@testing=${S3CMD_VERSION}" && \
    helm plugin install https://github.com/databus23/helm-diff --version "${HELMDIFF_VERSION}" && \
    helm repo add stable https://kubernetes-charts.storage.googleapis.com/
