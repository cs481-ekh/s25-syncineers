FROM debian:stable-slim AS build

RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    xz-utils

# Install flutter
RUN git clone https://github.com/flutter/flutter.git /flutter && \
    /flutter/bin/flutter --version

# Set Flutter environmental variable
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

WORKDIR /app

COPY easy_sync/pubspec.* ./
RUN flutter pub get
COPY easy_sync/ .

RUN flutter build web --release

# Use an official NGINX image to serve the web app
FROM nginx:stable-alpine

# Copy the built web files from the build stage to NGINX's html directory
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80
# Start NGINX
CMD ["nginx", "-g", "daemon off;"]