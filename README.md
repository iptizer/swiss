# swiss

Whis is my personal troubleshooting container. Currently the folowing tools are included:

* kubectl (latest stable)
* helm
* awscli (built from git master)
* dig (dnsutils)
* tcpdump
* nc/ netcat
* curl & wget
* traceroute & mtr


## Quickstart

### Kubernetes

(Note: Newer versions of kubectl deprecate the `--genrator` flag, see [StackOverflow](https://stackoverflow.com/questions/52890718/kubectl-run-is-deprecated-looking-for-alternative) linking to [this PR](https://github.com/kubernetes/kubernetes/pull/87077)) 

```sh
kubectl run -it --restart=Never --rm --generator=run-pod/v1 --image=iptizer/swiss swiss -- /bin/bash
```

### docker

```sh
docker run -it --rm iptizer/swiss -- /bin/bash
```

Including Proxy:

```sh
HTTP_PROXY="http://my.proxy"
NO_PROXY="127.0.0.1,localhost"
docker run --rm --env HTTP_PROXY=${HTTP_PROXY} --env HTTPS_PROXY=${HTTP_PROXY} --env http_proxy=${HTTP_PROXY} --env https_proxy=${HTTP_PROXY} --env NO_PROXY=${NO_PROXY} --env no_proxy=${NO_PROXY} -it iptizer/swiss /bin/bash
```
