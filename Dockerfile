FROM ghcr.io/cirruslabs/flutter:latest AS flutter-build

RUN apt-get update && apt-get install -y npm && \
    npm install -g serve

RUN useradd -m usertest

ARG APP_ROOT
ENV APP_ROOT=$APP_ROOT

WORKDIR /app

COPY . . 

RUN chown -R usertest:usertest /app
RUN chown -R usertest:usertest /sdks/flutter

USER usertest

RUN git config --global --add safe.directory /sdks/flutter

WORKDIR /app/easy_sync

RUN flutter clean

RUN flutter pub get

RUN flutter build web --base-href=/$APP_ROOT/

EXPOSE 7357

CMD ["serve", "-s", "build/web", "-l", "7357"]