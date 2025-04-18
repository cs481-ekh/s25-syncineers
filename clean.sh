#!/bin/bash
set -e

if find lib test -name '*.dart' | grep .; then 
    echo "Flutter files found"
    echo "Cleaning Flutter project..."
    flutter clean
    echo "Clean complete"
else
    echo "No Flutter files found, skipping clean."
fi