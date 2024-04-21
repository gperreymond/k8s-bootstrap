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

## Commands

```sh
# create the cluster
$ devbox run cluster-create
# prepare the cluster
$ devbox run cluster-prepare
# destroy the cluster
$ devbox run cluster-destroy
```

## Web sites

* https://traefik.docker.localhost/dashboard/#/
* https://argo-cd.docker.localhost/
* https://argo-workflows.docker.localhost/
* https://argo-rollouts.docker.localhost/rollouts/
* https://prometheus.docker.localhost/
* https://grafana.docker.localhost/