ARG GCLOUD_VERSION=slim
FROM google/cloud-sdk:${GCLOUD_VERSION}

# Use ARG so that values can be overriden by user/cloudbuild
ARG TERRAFORM_VERSION=0.13.7
ARG TERRAFORM_VERSION_SHA256SUM=4a52886e019b4fdad2439da5ff43388bbcc6cce9784fde32c53dcd0e28ca9957

ENV ENV_TERRAFORM_VERSION=$TERRAFORM_VERSION
ENV ENV_TERRAFORM_VERSION_SHA256SUM=$TERRAFORM_VERSION_SHA256SUM

RUN apt-get update && \
    apt-get -y install curl jq unzip git ca-certificates && \
    curl https://releases.hashicorp.com/terraform/${ENV_TERRAFORM_VERSION}/terraform_${ENV_TERRAFORM_VERSION}_linux_amd64.zip \
      > terraform_linux_amd64.zip && \
    echo "${ENV_TERRAFORM_VERSION_SHA256SUM} terraform_linux_amd64.zip" > terraform_SHA256SUMS && \
    sha256sum -c terraform_SHA256SUMS --status && \
    mkdir -p /builder && \
    unzip terraform_linux_amd64.zip -d /builder/terraform && \
    rm -f terraform_linux_amd64.zip terraform_SHA256SUMS && \
    apt-get --purge -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PATH=/builder/terraform/:$PATH
COPY entrypoint.bash /builder/entrypoint.bash
RUN chmod +x /builder/entrypoint.bash
ENTRYPOINT ["/builder/entrypoint.bash"]