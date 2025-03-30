FROM mcr.microsoft.com/powershell:lts-debian-11 AS build

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    xz-utils 

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter && \
    /flutter/bin/flutter --version

RUN /flutter/bin/flutter config

# Set Flutter environmental variable
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

WORKDIR /app

COPY easy_sync/pubspec.* ./
RUN flutter pub get

COPY easy_sync/ /app/easy_sync

RUN npm install -g serve

COPY build.ps1 /build.ps1

# Run pwsh script
RUN pwsh -ExecutionPolicy Bypass -File /build.ps1

EXPOSE 7357
CMD ["serve", "-s", "/app/easy_sync/build/web", "--listen", "7357"]
