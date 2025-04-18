#!/bin/bash
set -e

cd easy_sync

if find lib test -name '*.dart' | grep .; then 
    echo "Flutter files found"
    echo "Running all flutter tests designated in test/ directory..."
    flutter test
    echo "Tests complete"
else
    echo "No Flutter files found, skipping tests."
fi