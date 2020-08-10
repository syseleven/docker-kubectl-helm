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

Versions are mostly automatically updated by Renovate. Please check the
individual release for version numbers. This can alternatively be checked in
the global variables section of the [.gitlab-ci.yml](.gitlab-ci.yml#L24).
