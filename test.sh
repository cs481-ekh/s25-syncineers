#!/bin/bash
set -e

echo "Running all flutter tests designated in test/ directory..."
if flutter test; then
    echo "Tests complete."
else 
    echo "Tests failed." && exit 127
fi
