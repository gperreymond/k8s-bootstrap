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

* This project is a POC to manage k8s at edge clusters with the couple k3s/argo.
* Nomad server is installed as statefullset.

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
K3S_EDGE_TOKEN="ZZw3Xo.SIzIGQKHL8bHLs51"
```

```sh
# -----------------------------
# prepare docker network
# -----------------------------
# to simulate the private network
$ docker network create --driver bridge --subnet 172.29.0.0/16 k8s-bootstrap
```

```sh
# -----------------------------
# k8s controller cluster
# -----------------------------
$ devbox run controller:start
# stop the k8s controller cluster
$ devbox run controller:stop
```

```sh
# -----------------------------
# k8s edge cluster
# -----------------------------
$ devbox run edge:start
# stop the k8s edge cluster
$ devbox run edge:stop
```

```
CONTAINER ID   IMAGE                      COMMAND                  CREATED          STATUS          PORTS                                                                      NAMES
de7402dbd381   rancher/k3s:v1.29.4-k3s1   "/bin/k3s agent --no…"   15 seconds ago   Up 13 seconds                                                                              edge-agent
e8b98f73c3cf   rancher/k3s:v1.29.4-k3s1   "/bin/k3s server --d…"   15 seconds ago   Up 14 seconds                                                                              edge-server
8781698f2fdb   rancher/k3s:v1.29.4-k3s1   "/bin/k3s agent --no…"   21 seconds ago   Up 19 seconds                                                                              controller-agent
04eb9fd9599d   rancher/k3s:v1.29.4-k3s1   "/bin/k3s server --d…"   21 seconds ago   Up 20 seconds   0.0.0.0:80->80/tcp, :::80->80/tcp, 0.0.0.0:443->443/tcp, :::443->443/tcp   controller-server
```

```sh
# -----------------------------
# last step get the 2 kubeconfigs
# -----------------------------
$ devbox run kubeconfigs
```

## Terraform

```sh
# -----------------------------
# time to terraform the edge
# -----------------------------
$ devbox run edge:tf init
$ devbox run edge:tf apply
# -----------------------------
# time to terraform the controller
# -----------------------------
# because of issue: https://github.com/hashicorp/terraform-provider-kubernetes/issues/1583
$ devbox run controller:tf init
$ devbox run controller:tf apply -target helm_release.argo_cd
# once the target is done, you can do:
$ devbox run controller:tf apply
```

## Local URLs

* https://traefik.docker.localhost/dashboard/#/
* https://argo-cd.docker.localhost/
* https://argo-workflows.docker.localhost/
* https://prometheus.docker.localhost/
* https://grafana.docker.localhost/

# Documentations

* https://blog.mossroy.fr/2024/04/16/passage-sur-metallb-au-lieu-de-servicelb-sur-un-cluster-k3s
