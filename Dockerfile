FROM ghcr.io/cirruslabs/flutter:latest AS flutter-Build

ARG APP_ROOT
ENV APP_ROOT=$APP_ROOT

WORKDIR /app

COPY . . 

WORKDIR /app/easy_sync

RUN flutter clean

RUN flutter pub get

RUN flutter build web

RUN apt-get update && apt-get install -y npm && \
    npm install -g serve

EXPOSE 7357

CMD ["serve", "-s", "build/web", "-l", "7357"]