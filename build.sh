#!/bin/bash
set -e # Exit on error

echo "Installing flutter dependencies..."
flutter config --enable-windows-desktop
flutter pub get

echo "Building Flutter Windows App..."
if flutter build windows; then
    echo "Build Complete"
else    
    echo "Build Failed" && exit 127
fi
