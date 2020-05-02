FROM ubuntu:rolling

WORKDIR /

# install basic tools
RUN apt-get update && apt-get install -y curl less groff dnsutils netcat tcpdump wget traceroute mtr rclone mariadb-client

# build aws cli from git master
RUN apt-get install -y python3 python3-pip git
RUN git clone --depth=1 https://github.com/aws/aws-cli.git
RUN pip3 install aws-cli/

# kubectl
RUN curl -o /usr/local/sbin/kubectl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && chmod 777 /usr/local/sbin/kubectl

# helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && chmod 700 get_helm.sh && ./get_helm.sh && rm ./get_helm.sh

ENTRYPOINT ["/bin/bash","-c"]
CMD ["bash"]
