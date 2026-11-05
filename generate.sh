#!/bin/bash
set -e
cd "$(dirname "$0")"

API_URL="${GRAPHQL_URL:-http://localhost:4002/graphql}"

echo "1. Cleaning previous build_runner cache and codegen..."
dart run build_runner clean
find lib -type d -name "__generated__" -exec rm -rf {} + 2>/dev/null || true
find lib -type f -name "*.graphql.dart" -delete 2>/dev/null || true
rm -f lib/core/graphql/schema.graphql

echo "2. Fetching live GraphQL schema from $API_URL..."
if ! npx -y get-graphql-schema "$API_URL" > lib/core/graphql/schema.graphql; then
  echo "Error: Failed to fetch schema from $API_URL. Ensure your API server is running (e.g. npm run dev in prod/api-server)."
  exit 1
fi

echo "3. Generating GraphQL strongly-typed Dart classes..."
dart run build_runner build

echo "Codegen and schema updated successfully."
