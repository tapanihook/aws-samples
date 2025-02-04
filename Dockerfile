FROM python:3.10.4-slim-bullseye

ENV POETRY_VERSION 1.1.13

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    # deps for installing pulumi
    curl unzip vim \
    # deps for building python deps
    build-essential \
    # deps for kubectl
    apt-transport-https ca-certificates

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y kubectl

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh

RUN set -ex; pip install --no-cache-dir poetry==$POETRY_VERSION;
RUN curl -fsSL https://get.pulumi.com | sh  && \
    mv /root/.pulumi/bin/* /usr/bin

RUN apt-get install nodejs npm -y
#ENV PATH="/root/.pulumi/bin:$PATH"

ENV VIRTUAL_ENV=/workspaces/aws-architectures/pulumi/.venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN poetry config virtualenvs.in-project true
