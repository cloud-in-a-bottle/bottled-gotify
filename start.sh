#!/bin/sh
set -e

PERSIST="${OPENHOST_APP_DATA_DIR:-/data}"
ADMIN_PASS_FILE="$PERSIST/.admin_password"

mkdir -p "$PERSIST/data" "$PERSIST/images" "$PERSIST/plugins"

# ---------------------------------------------------------------------------
# Generate and persist admin password on first boot
# ---------------------------------------------------------------------------
if [ ! -f "$ADMIN_PASS_FILE" ]; then
    ADMIN_PASS=$(head -c 32 /dev/urandom | base64 | tr -d '\n/+=' | head -c 24)
    echo -n "$ADMIN_PASS" > "$ADMIN_PASS_FILE"
    chmod 600 "$ADMIN_PASS_FILE"
fi
ADMIN_PASS=$(cat "$ADMIN_PASS_FILE")

echo "======================================"
echo "Gotify admin user:     admin"
echo "Gotify admin password: $ADMIN_PASS"
echo "======================================"

# ---------------------------------------------------------------------------
# Gotify configuration via environment variables
# ---------------------------------------------------------------------------
export GOTIFY_SERVER_PORT=8080
export GOTIFY_DATABASE_DIALECT=sqlite3
export GOTIFY_DATABASE_CONNECTION="$PERSIST/data/gotify.db"
export GOTIFY_DEFAULTUSER_NAME=admin
export GOTIFY_DEFAULTUSER_PASS="$ADMIN_PASS"
export GOTIFY_UPLOADEDIMAGESDIR="$PERSIST/images"
export GOTIFY_PLUGINSDIR="$PERSIST/plugins"
export GOTIFY_REGISTRATION=false

# Trust OpenHost router proxy for X-Forwarded-For/Host/Proto headers
export GOTIFY_SERVER_TRUSTEDPROXIES='[10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,127.0.0.1]'

# Allow CORS from the external domain (browser sends Origin header through proxy)
export GOTIFY_SERVER_CORS_ALLOWORIGINS='[.+]'
export GOTIFY_SERVER_CORS_ALLOWMETHODS='[GET,POST,PUT,DELETE,PATCH,OPTIONS]'
export GOTIFY_SERVER_CORS_ALLOWHEADERS='[Authorization,Content-Type,X-Gotify-Key]'
export GOTIFY_SERVER_STREAM_ALLOWEDORIGINS='[.+]'

exec /app/gotify-app
