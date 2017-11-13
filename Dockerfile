FROM anapsix/alpine-java:8_jdk

ARG SCALA_VERSION=2.12.4
ARG SBT_VERSION=0.13.16
ENV SBT_HOME=/usr/local/sbt
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/jdk/bin:/usr/local/sbt/bin
ENV KOPS_VERSION=1.7.1
ENV KUBECTL_VERSION=v1.8.3

# Install docker
RUN set -x && \
    apk add --no-cache docker

# Install the AWS CLI
RUN set -x && \
    apk add --no-cache bash ca-certificates coreutils curl gawk git grep groff gzip jq less python sed tar xz zip zlib && \
    curl -sSL https://s3.amazonaws.com/aws-cli/awscli-bundle.zip -o awscli-bundle.zip && \
    unzip awscli-bundle.zip && \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
    rm awscli-bundle.zip && \
    rm -Rf awscli-bundle && \
    cat /etc/alpine-release

# Install sbt
RUN set -x && \
    curl -sSL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
    echo >> /root/.bashrc && \
    echo 'export PATH=~/scala-$SCALA_VERSION/bin:$PATH' >> /root/.bashrc && \
    mkdir $SBT_HOME && \
    curl -sSL https://cocl.us/sbt${SBT_VERSION//./}tgz | gunzip | tar --strip-components=1 -x -C $SBT_HOME

# Install kubectl and kops
# Note: Latest version may be found on:
# https://aur.archlinux.org/packages/kubectl-bin/

RUN apk --no-cache add ca-certificates \
  && apk --no-cache add --virtual build-dependencies curl \
  && curl -O --location --silent --show-error https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64 \
  && mv kops-linux-amd64 /usr/local/bin/kops \
  && curl -LO https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl \
  && mv kubectl /usr/local/bin/kubectl \
  && chmod +x /usr/local/bin/kops /usr/local/bin/kubectl \
  && apk del --purge build-dependencies

ENV HOME=/config

RUN set -x && \
    apk add --no-cache curl ca-certificates && \
    chmod +x /usr/local/bin/kubectl && \
    \
    # Create non-root user (with a randomly chosen UID/GUI).
    adduser kubectl -Du 2342 -h /config && \
    env &&\
    # Basic check it works.
    kubectl version --client


WORKDIR /root
