FROM alpine:latest as downloader

RUN apk add curl
RUN curl -L -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.16.0/bin/linux/amd64/kubectl
RUN curl -sS https://get.helm.sh/helm-v3.0.3-linux-amd64.tar.gz | tar xz
RUN curl -L -o /usr/bin/helmfile https://github.com/roboll/helmfile/releases/download/v0.98.2/helmfile_linux_amd64
RUN chmod +x /usr/bin/kubectl linux-amd64/* /usr/bin/helmfile

FROM alpine:latest
COPY --from=downloader /usr/bin/kubectl /usr/bin/kubectl
COPY --from=downloader linux-amd64/helm /usr/bin/helm
COPY --from=downloader /usr/bin/helmfile /usr/bin/helmfile
RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk --update add --no-cache git bash curl make openssl coreutils pv 's3cmd@testing=2.0.2-r2' && \
    helm plugin install https://github.com/databus23/helm-diff --version master && \
    helm repo add stable https://kubernetes-charts.storage.googleapis.com/
