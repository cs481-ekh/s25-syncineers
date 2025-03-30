# FROM debian:stable-slim AS build
# FROM mcr.microsoft.com/powershell:debian AS build
# FROM mcr.microsoft.com/powershell:lts-debian-11 AS build
# FROM cirrusci/flutter:stable AS build

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

# Set Flutter environmental variable
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

WORKDIR /app

COPY easy_sync/pubspec.* ./
RUN flutter pub get

COPY easy_sync/ /app/easy_sync

COPY build.ps1 /build.ps1

# Run pwsh script
RUN pwsh -ExecutionPolicy Bypass -File /build.ps1

# NGINX image
# FROM nginx:stable-alpine
# COPY --from=build /app/easy_sync/build/web /usr/share/nginx/html

FROM node:18-alpine AS runtime
WORKDIR /app
RUN npm install -g serve
COPY --from=build /app/easy_sync/build/web /app/web


EXPOSE 7357
CMD ["serve", "-s", "web", "-l", "7357"]
