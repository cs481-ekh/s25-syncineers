#!/bin/bash
set -e

if find lib test -name '*.dart' | grep .; then 
    echo "Flutter files found"
    echo "Cleaning build artifacts..."
    flutter clean
    echo "Clean complete"
else
    echo "No Flutter files found, will not clean files."
fi
