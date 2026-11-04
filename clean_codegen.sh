#!/bin/bash
set -e
cd "$(dirname "$0")"

echo "1. Cleaning build_runner cache..."
dart run build_runner clean

echo "2. Deleting all __generated__ folders and *.graphql.dart files..."
find lib -type d -name "__generated__" -exec rm -rf {} + 2>/dev/null || true
find lib -type f -name "*.graphql.dart" -delete 2>/dev/null || true

echo "3. Deleting schema.graphql..."
rm -f lib/core/graphql/schema.graphql

echo "Codegen files and schema.graphql deleted successfully."
