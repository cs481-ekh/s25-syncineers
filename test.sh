#!/bin/bash
set -e

echo "Running all flutter tests designated in test/ directory..."
flutter test --coverage

echo "Tests complete."