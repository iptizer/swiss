FROM ubuntu:rolling

WORKDIR /

# hack from https://rtfm.co.ua/en/docker-configure-tzdata-and-timezone-during-build/
# to survive tzdata installation
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install basic tools
RUN apt-get update && apt-get install -y curl less groff dnsutils netcat tcpdump wget traceroute mtr rclone mariadb-client vim iputils-ping ncdu

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
