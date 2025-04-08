FROM ghcr.io/cirruslabs/flutter:latest AS flutter-build

RUN apt-get update && apt-get install -y npm && \
    npm install -g serve

RUN useradd -m usertest

WORKDIR /app

COPY . . 

RUN chown -R usertest:usertest /app
RUN chown -R usertest:usertest /sdks/flutter

USER usertest

RUN git config --global --add safe.directory /sdks/flutter

WORKDIR /app/easy_sync

RUN flutter clean

RUN flutter pub get

RUN flutter build web

EXPOSE 7357

CMD ["serve", "-s", "build/web", "-l", "7357"]