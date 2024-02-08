
# Image qui contient Azure Powershell
FROM mcr.microsoft.com/azure-powershell:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    git \
    iputils-ping \
    jq \
    lsb-release \
    software-properties-common \
    nodejs \
    npm \
    python3-pip \
    unzip   

# Installation Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install SQLPackage
# Download and install SQLPackage
WORKDIR /tmp
RUN curl -o sqlpackage.zip -L https://aka.ms/sqlpackage-linux && \
    unzip sqlpackage.zip -d /opt/sqlpackage && \
    chmod +x /opt/sqlpackage/sqlpackage && \
    ln -s /opt/sqlpackage/sqlpackage /usr/local/bin/sqlpackage
   
# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ENV TARGETARCH=linux-x64

WORKDIR /azp

COPY ./start.sh .

RUN chmod +x start.sh

ENTRYPOINT [ "./start.sh" ]