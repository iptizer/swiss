FROM ubuntu:latest
ARG TARGETARCH

WORKDIR /

# debug
RUN echo "ARCH: $TARGETARCH"

# set bash as default shell
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# hack from https://rtfm.co.ua/en/docker-configure-tzdata-and-timezone-during-build/
# to survive tzdata installation
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install basic tools
RUN apt-get update && apt-get install -y curl less groff dnsutils netcat-traditional tcpdump wget \
    traceroute mtr rclone mariadb-client vim pv jq iputils-ping ncdu tmux iperf3 \
    iproute2 unzip gnupg software-properties-common sudo libssl-dev

# install aws cli as explained in docs https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#cliv2-linux-install
RUN if [[ "$TARGETARCH" == "amd64" ]] ; then export AWSARCH="x86_64" ; else export AWSARCH="aarch64" ; fi && \
    apt-get install -y python3 python3-pip git && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-${AWSARCH}.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    sudo ./aws/install

# git-crypt
# RUN git clone https://github.com/AGWA/git-crypt.git && \
#     cd git-crypt && make && make install && cd .. && rm -rf git-crypt

# aws-iam-authenticator
RUN curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/${TARGETARCH}/aws-iam-authenticator && \
    chmod +x ./aws-iam-authenticator && mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && \
    export PATH=$PATH:$HOME/bin && echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc && echo 'export PATH=$PATH:$HOME/bin' >> ~/.bash_profile

# kubectl
RUN curl -o /usr/local/sbin/kubectl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/${TARGETARCH}/kubectl && chmod 777 /usr/local/sbin/kubectl

# helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && chmod 700 get_helm.sh && ./get_helm.sh && rm ./get_helm.sh

# tfenv
RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv && \
    echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile && \
    echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bashrc && \
    ~/.tfenv/bin/tfenv install 0.12.31 && \
    ~/.tfenv/bin/tfenv use 0.12.31 && \
    curl -Lo terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v0.31.4/terragrunt_linux_amd64 && \
    chmod u+x terragrunt && \
    mv terragrunt /usr/local/bin/terragrunt 

# skopeo
RUN . /etc/os-release && \
    echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/x${ID^}_${VERSION_ID}/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list && \
    wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/x${ID^}_${VERSION_ID}/Release.key -O Release.key && \
    apt-key add - < Release.key && apt-get -y update && apt-get -y install skopeo


ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-${TARGETARCH} /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "-s","--"]
