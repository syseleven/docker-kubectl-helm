FROM alpine:latest as downloader

RUN apk add curl
RUN curl -L -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.16.0/bin/linux/amd64/kubectl
RUN curl -sS https://get.helm.sh/helm-v2.15.1-linux-amd64.tar.gz | tar xz
RUN chmod +x /usr/bin/kubectl linux-amd64/*

FROM alpine:latest
COPY --from=downloader /usr/bin/kubectl /usr/bin/kubectl
COPY --from=downloader linux-amd64/helm /usr/bin/helm
RUN apk --update add --no-cache git bash curl make && \
    helm init --client-only && \
    helm plugin install https://github.com/databus23/helm-diff --version master
