# swiss

[![build-multiarch](https://github.com/iptizer/swiss/actions/workflows/build.yml/badge.svg)](https://github.com/iptizer/swiss/actions/workflows/build.yml)

Troubleshooting container with lots of tools installed.

Supported architectures:

* **amd64** (x86_64)
* **arm64** (aarch64)

Container is available on docker hub: [https://hub.docker.com/r/iptizer/swiss](https://hub.docker.com/r/iptizer/swiss)

## Quickstart



### Kubernetes

```sh
kubectl run -it --restart=Never --rm --image=iptizer/swiss swiss
```

Deployment/ daemonset within this repo may be used. There are two versions provided:

* Deployment: swiss
* DaemonSet: swiss-host (Extended privileges with host mounted on pod. Use with caution!)

```sh
kubectl create ns troubleshoot

# daemonset
kubectl apply -n troubleshoot -f daemonset.yaml
kubectl get po -n troubleshoot
kubectl exec -it swiss-577np -- bash
kubectl delete -f daemonset.yaml

# deploy - Copy & paste will work
kubectl apply -n troubleshoot -f deployment.yaml
kubectl scale -n troubleshoot --replicas=1 deploy/swiss
kubectl wait  -n troubleshoot --timeout=600s --for=condition=available deploy/swiss && \
kubectl exec -n troubleshoot -it $( k get po -l "app=swiss" -o jsonpath='{.items[0].metadata.name}' )
kubectl scale -n troubleshoot --replicas=0 deploy/swiss
kubectl delete -f deployment.yaml

# job
kubectl apply -n troubleshoot -f job.yaml
```

### docker

```sh
docker run -it --rm iptizer/swiss -- /bin/bash
```

Including Proxy:

```sh
HTTP_PROXY="http://my.proxy"
NO_PROXY="127.0.0.1,localhost"
docker run --rm --env HTTP_PROXY=${HTTP_PROXY} --env HTTPS_PROXY=${HTTP_PROXY} --env http_proxy=${HTTP_PROXY} --env https_proxy=${HTTP_PROXY} --env NO_PROXY=${NO_PROXY} --env no_proxy=${NO_PROXY} -it iptizer/swiss
```

## Manual local build

Both architectures:

```sh
docker login
docker buildx build --push --platform linux/arm64,linux/amd64 -t iptizer/swiss:latest .
```

Only arm64:

```sh
docker build . -t iptizer/swiss:latest
docker push iptizer/swiss:latest
```

## local devbox

To start the local devbox and install new packages proceed as follows:

```sh
devbox shell

```

## Use cases

### Troubleshooting disc pressure on node

To debug disc space on a node, use *swiss-host*. We can then attach to the pod on the host we are interested, use *ncdu* and hopefully find the problem.

### Jumphost

Connect to a swiss pod and use *tmux* to jump whereever you want.


