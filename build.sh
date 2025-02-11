#!/bin/bash
set -e # Exit on error

if find lib test -name '*.dart' | grep .; then
    echo "Flutter files found"
    echo "Installing flutter dependencies..."
    flutter config --enable-windows-desktop
    flutter pub get

    echo "Building Flutter Windows App..."
    if flutter build windows; then
        echo "Build Complete"
    else    
        echo "Build Failed" && exit 127
    fi
else
    echo "No Flutter files found, skipping build."
fi