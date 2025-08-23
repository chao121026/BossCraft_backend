#!/bin/bash
set -e

echo "=== Railway Environment Detection ==="

# 如果 Railway 提供了 DATABASE_URL，解析它
if [ ! -z "$DATABASE_URL" ]; then
    echo "Found DATABASE_URL, parsing..."
    # 这里可以解析 DATABASE_URL 并设置 PG* 变量
fi

# 映射 Railway 变量到 Odoo 期望的变量
export PGHOST=${PGHOST:-${DATABASE_HOST:-"localhost"}}
export PGPORT=${PGPORT:-${DATABASE_PORT:-"5432"}}
export PGUSER=${PGUSER:-${DATABASE_USER:-"postgres"}}
export PGPASSWORD=${PGPASSWORD:-${DATABASE_PASSWORD:-""}}
export PGDATABASE=${PGDATABASE:-${DATABASE_NAME:-"railway"}}
export ADMIN_PASSWORD=${ADMIN_PASSWORD:-"admin123"}

echo "Final database config:"
echo "  Host: $PGHOST"
echo "  Port: $PGPORT"
echo "  User: $PGUSER"
echo "  Database: $PGDATABASE"

# 检查必要的变量
if [ -z "$PGHOST" ] || [ -z "$PGPASSWORD" ]; then
    echo "Error: Missing required database variables"
    echo "Please set PGHOST, PGPASSWORD, etc. in Railway"
    exit 1
fi

envsubst < /etc/odoo/odoo.conf.template > /etc/odoo/odoo.conf

echo "Generated config:"
cat /etc/odoo/odoo.conf

exec "$@"
