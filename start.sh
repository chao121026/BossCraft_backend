#!/bin/bash
set -e

echo "=== Debug Environment Variables ==="
echo "PGHOST: '$PGHOST'"
echo "PGPORT: '$PGPORT'"
echo "PGUSER: '$PGUSER'"
echo "PGPASSWORD: '$PGPASSWORD'"
echo "PGDATABASE: '$PGDATABASE'"
echo "ADMIN_PASSWORD: '$ADMIN_PASSWORD'"

echo "=== All environment variables ==="
env | grep -E '^(PG|ADMIN|DATABASE)' || echo "No database variables found"

echo "=== Original template file ==="
cat /etc/odoo/odoo.conf.template

echo "=== Running envsubst ==="
envsubst < /etc/odoo/odoo.conf.template > /etc/odoo/odoo.conf

echo "=== Generated config file ==="
cat /etc/odoo/odoo.conf

echo "=== Starting Odoo ==="
exec "$@"
