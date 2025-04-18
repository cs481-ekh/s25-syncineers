#!/bin/bash
set -e # Exit on error

cd ~/easy_sync

if find lib test -name '*.dart' | grep .; then
    echo "Flutter files found"
    echo "Installing Flutter dependencies..."
    flutter pub get

    echo "Building Flutter project..."
    if flutter build web; then
        echo "Build succeeded"
    else
        echo "Build failed" && exit 127
        exit 1
    fi

else
    echo "No Flutter files found, skipping build."

fi