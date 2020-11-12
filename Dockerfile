FROM ubuntu:latest

WORKDIR /

# install basic tools
RUN apt-get update && apt-get install -y curl less groff dnsutils netcat tcpdump wget traceroute mtr rclone mariadb-client vim pv jq

# build aws cli from git master
RUN apt-get install -y python3 python3-pip git
RUN git clone --depth=1 https://github.com/aws/aws-cli.git
RUN pip3 install aws-cli/

# kubectl
RUN curl -o /usr/local/sbin/kubectl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && chmod 777 /usr/local/sbin/kubectl

# helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && chmod 700 get_helm.sh && ./get_helm.sh && rm ./get_helm.sh

# skopeo
RUN . /etc/os-release && \
echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/x${ID^}_${VERSION_ID}/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list && \
wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/x${ID^}_${VERSION_ID}/Release.key -O Release.key && \
apt-key add - < Release.key && apt-get -y update && apt-get -y install skopeo


ENTRYPOINT ["/bin/bash","-c"]
CMD ["bash"]
