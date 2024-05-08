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
# create the 3 instances: k8s-controller and k8s-worker-001/k8s-worker-002
# each instance will be a kubernetes cluster, deployed with k3d
# k8s-controller, has argo (cd/workflows/events) and monitoring(prometheus/grafana)
# k8s-worker-001/k8s-worker-002, have nothing, all will be deployed by argo-cd himself
$ devbox run instances:create
# reload instances bootstraping
$ devbox run instances:bootstrap
# get all kubeconfigs locally
$ devbox run kubeconfigs
# delete all
$ devbox run instances:delete
```

## Web sites

* https://traefik.docker.localhost/dashboard/#/
* https://argo-cd.docker.localhost/
* https://argo-workflows.docker.localhost/
* https://argo-rollouts.docker.localhost/rollouts/
* https://prometheus.docker.localhost/
* https://grafana.docker.localhost/