# swiss

[![build-multiarch](https://github.com/iptizer/swiss/actions/workflows/build.yml/badge.svg)](https://github.com/iptizer/swiss/actions/workflows/build.yml)

Troubleshooting container with a rich set of modern developer and diagnostic tools managed via Jetify Devbox.

Supported architectures:

* **amd64** (x86_64)
* **arm64** (aarch64)

Container is available on docker hub: [https://hub.docker.com/r/iptizer/swiss](https://hub.docker.com/r/iptizer/swiss)

### Features & Included Tools

* **Core Utilities:** `curl`, `wget`, `netcat`, `tcpdump`, `dnsutils`, `git`, `jq`, `yq-go`, `tmux`, `vim`, `pv`
* **Kubernetes Suite:** `kubectl`, `kubectx`, `kubernetes-helm`, `k9s`, `stern`
* **Cloud & IaC:** `awscli2`, `google-cloud-sdk`, `terraform`, `terragrunt`, `opentofu`, `tenv`
* **Modern CLI Replacements:** `doggo` (dig), `btop` (htop/top), `eza` (ls), `bat` (cat), `fd` (find), `ripgrep` (grep), `fzf` (fuzzy finder)
* **Networking & Storage:** `mtr`, `rclone`, `mariadb-client`, `ncdu`, `duf`, `iperf3`

The Nix environment is automatically loaded into the PATH on interactive shells (`bash`).

## Quickstart

### Kubernetes

```sh
kubectl run -it --restart=Never --rm --image=iptizer/swiss swiss -- bash
```

Deployment/ daemonset within this repo may be used. There are two versions provided:

* Deployment: swiss
* DaemonSet: swiss-host (Extended privileges with host mounted on pod. Use with caution!)

```sh
kubectl create ns troubleshoot

# daemonset
kubectl apply -n troubleshoot -f daemonset.yaml
kubectl get po -n troubleshoot
kubectl exec -it swiss-577np -n troubleshoot -- bash
kubectl delete -f daemonset.yaml

# deploy - Copy & paste will work
kubectl apply -n troubleshoot -f deployment.yaml
kubectl scale -n troubleshoot --replicas=1 deploy/swiss
kubectl wait  -n troubleshoot --timeout=600s --for=condition=available deploy/swiss && \
kubectl exec -n troubleshoot -it $( k get po -l "app=swiss" -o jsonpath='{.items[0].metadata.name}' ) -- bash
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


