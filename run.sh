#!/bin/bash
set -e
cd "$(dirname "$0")"

API_URL="${GRAPHQL_URL:-http://localhost:4002/graphql}"
LOCAL_IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "192.168.1.153")

echo "==========================================="
echo "  PayrollNeo Flutter One-Shot Pipeline"
echo "==========================================="

echo "1. Cleaning previous codegen & schema..."
dart run build_runner clean
find lib -type d -name "__generated__" -exec rm -rf {} + 2>/dev/null || true
find lib -type f -name "*.graphql.dart" -delete 2>/dev/null || true
rm -f lib/core/graphql/schema.graphql

echo "2. Fetching live GraphQL schema from $API_URL..."
if ! npx -y get-graphql-schema "$API_URL" > lib/core/graphql/schema.graphql; then
  echo "Error: Failed to fetch schema from $API_URL. Ensure your API server is running (e.g. npm run dev in prod/api-server)."
  exit 1
fi

echo "3. Generating strongly-typed GraphQL Dart classes..."
dart run build_runner build

echo "4. Launching Flutter app (Host IP: http://${LOCAL_IP}:4002)..."
EXTRA_ARGS=()
if [ $# -gt 0 ] && [[ "$1" != -* ]] && [ ! -f "$1" ]; then
  EXTRA_ARGS=("-d" "$1")
  shift
fi

flutter run --dart-define=API_BASE_URL="http://${LOCAL_IP}:4002" "${EXTRA_ARGS[@]}" "$@"
