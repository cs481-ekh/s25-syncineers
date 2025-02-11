#!/bin/bash
set -e # Exit on error

echo "Installing flutter dependencies..."
flutter config --enable-windows-desktop
flutter pub get

echo "Building Flutter Windows App..."
flutter build windows

echo "Build Complete"