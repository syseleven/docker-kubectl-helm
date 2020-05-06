FROM alpine:3.11.3 as downloader

# This is a builder image, we do not need cache maintenance here
# hadolint ignore=DL3019
RUN apk add curl
RUN curl -sS https://get.helm.sh/helm-v3.2.0-linux-amd64.tar.gz | tar xz
RUN curl -L -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.18.2/bin/linux/amd64/kubectl
RUN curl -L -o /usr/bin/helmfile https://github.com/roboll/helmfile/releases/download/v0.114.0/helmfile_linux_amd64
RUN chmod +x /usr/bin/kubectl linux-amd64/* /usr/bin/helmfile

FROM alpine:3.11.3
COPY --from=downloader /usr/bin/kubectl /usr/bin/kubectl
COPY --from=downloader linux-amd64/helm /usr/bin/helm
COPY --from=downloader /usr/bin/helmfile /usr/bin/helmfile
RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk --update add --no-cache git bash curl make openssl coreutils pv 's3cmd@testing=2.1.0-r0' && \
    helm plugin install https://github.com/databus23/helm-diff --version master && \
    helm repo add stable https://kubernetes-charts.storage.googleapis.com/
