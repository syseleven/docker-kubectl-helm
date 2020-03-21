FROM alpine:3.11.3 as downloader

RUN apk add --no-cache 'curl=7.67.0-r0'
# hadolint ignore=DL4006
RUN curl -sS https://get.helm.sh/helm-v3.1.2-linux-amd64.tar.gz | tar xz
RUN curl -L -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.17.3/bin/linux/amd64/kubectl
RUN curl -L -o /usr/bin/helmfile https://github.com/roboll/helmfile/releases/download/v0.102.0/helmfile_linux_amd64
RUN chmod +x /usr/bin/kubectl linux-amd64/* /usr/bin/helmfile

FROM alpine:3.11.3
COPY --from=downloader /usr/bin/kubectl /usr/bin/kubectl
COPY --from=downloader linux-amd64/helm /usr/bin/helm
COPY --from=downloader /usr/bin/helmfile /usr/bin/helmfile
RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk --update add --no-cache \
    'git=2.24.1-r0' \
    'bash=5.0.11-r1' \
    'curl=7.67.0-r0' \
    'make=4.2.1-r2' \
    'openssl=1.1.1d-r3' \
    'coreutils=8.31-r0' \
    'pv=1.6.6-r1' \
    's3cmd@testing=2.0.2-r2' \
  && helm plugin install https://github.com/databus23/helm-diff --version master \
  && helm repo add stable https://kubernetes-charts.storage.googleapis.com/
