# This is a toolbox image

It contains Kubectl Helm Git etc. for daily business on the CLI and in CI
pipelines.

## How to use it

You can docker pull it from <https://hub.docker.com/r/syseleven/kubectl-helm>

## Release naming

### 4.x.y+

Releases are named using [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html).

### Before 4.0.0

Releases are named `helm-x.y.z` after the contained helm version.

If updates are published without changing the helm version,
they are numbered `helm-x.y.z-NUMBER`, starting from `1`.

## Contained software versions

The image is based on alpine:3.12.0.

* Kubectl 1.18.5
* Helm 3.2.4
  * helm diff latest
  * helm-git latest
* Git latest
* helmfile v0.119.1
* s3cmd v2.1.0-r1
