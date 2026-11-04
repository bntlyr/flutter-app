#!/bin/bash
set -e
cd "$(dirname "$0")"

API_URL="${GRAPHQL_URL:-http://localhost:4002/graphql}"

echo "1. Fetching live GraphQL schema from $API_URL..."
if ! npx -y get-graphql-schema "$API_URL" > lib/core/graphql/schema.graphql; then
  echo "Error: Failed to fetch schema. Make sure your API server is running on $API_URL (e.g. npm run dev in prod/api-server)."
  exit 1
fi

echo "2. Generating GraphQL strongly-typed Dart classes..."
dart run build_runner build

echo "Generation complete."
