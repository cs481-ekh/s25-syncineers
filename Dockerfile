# FROM debian:stable-slim AS build
# FROM mcr.microsoft.com/powershell:debian AS build
#FROM mcr.microsoft.com/powershell:lts-debian-11 AS build
#FROM cirrusci/flutter:stable AS build

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

# Run PowerShell script
RUN pwsh -ExecutionPolicy Bypass -File /build.ps1

# Use an official NGINX image to serve the web app
FROM nginx:stable-alpine

# Copy the built web files from the build stage to NGINX's html directory
COPY --from=build /app/easy_sync/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
