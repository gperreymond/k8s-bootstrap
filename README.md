# KUBERNETES DEVOPS BOOTSTRAP

## Getting Started
This project uses [devbox](https://github.com/jetpack-io/devbox) to manage its development environment.

Install devbox:
```sh
curl -fsSL https://get.jetpack.io/devbox | bash
```

Start the devbox shell:
```sh 
devbox shell
```

## General purpose

This project is a POC to manage k8s at edge clusters with argo.

## Commands

```sh
# -----------------------------
# prepare env vars
# -----------------------------
# you need to generate token for k3s clusters, in our case twice
$ ./scripts/generate-token.sh
# create a .env file with those two tokens
```

```txt
K3S_VERSION="v1.29.4-k3s1"
K3S_CONTROLLER_TOKEN="yYkWDY.cpIhCbSA9gV5FJRl"
K3S_WORKER_TOKEN="ZZw3Xo.SIzIGQKHL8bHLs51"
```

```sh
# start the k8s controller cluster
$ devbox run controller:start
#stop the k8s controller cluster
$ devbox run controller:stop
```

## Terraform

```sh
# time to terraform the controller
$ devbox run controller:tf [init apply, plan, etc]
```

## Web sites

* https://traefik.docker.localhost/dashboard/#/
* https://argo-cd.docker.localhost/
* https://argo-workflows.docker.localhost/
* https://argo-rollouts.docker.localhost/rollouts/
* https://prometheus.docker.localhost/
* https://grafana.docker.localhost/