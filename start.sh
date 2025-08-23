#!/bin/bash
set -e

echo "=== BossCraft Odoo Startup ==="
echo "Starting BossCraft Unified Dashboard..."

# 显示Railway服务信息
echo "Railway Service: ${RAILWAY_SERVICE_NAME:-unknown}"
echo "Railway Environment: ${RAILWAY_ENVIRONMENT_NAME:-unknown}"

# 检查数据库变量
echo "=== Database Configuration ==="
echo "HOST: ${DATABASE_HOST:-[not set]}"
echo "PORT: ${DATABASE_PORT:-[not set]}"
echo "USER: ${DATABASE_USER:-[not set]}"
echo "NAME: ${DATABASE_NAME:-[not set]}"

# 设置默认值以防变量未设置
export DATABASE_HOST=${DATABASE_HOST:-"postgres"}
export DATABASE_PORT=${DATABASE_PORT:-"5432"}
export DATABASE_USER=${DATABASE_USER:-"postgres"}
export DATABASE_PASSWORD=${DATABASE_PASSWORD:-""}
export DATABASE_NAME=${DATABASE_NAME:-"railway"}
export ADMIN_PASSWORD=${ADMIN_PASSWORD:-"BossCraft2024!"}

# 验证必要的变量
if [ -z "$DATABASE_PASSWORD" ]; then
    echo "⚠️  WARNING: DATABASE_PASSWORD is empty. This may cause connection issues."
fi

# 生成Odoo配置文件
echo "=== Generating Odoo Configuration ==="
envsubst < /etc/odoo/odoo.conf.template > /etc/odoo/odoo.conf

echo "Generated configuration:"
cat /etc/odoo/odoo.conf

# 验证插件目录
echo "=== Verifying Addons ==="
if [ -d "/mnt/extra-addons/boss_craft_unified_dashboard" ]; then
    echo "✅ BossCraft module found!"
    echo "Module contents:"
    ls -la /mnt/extra-addons/boss_craft_unified_dashboard/
else
    echo "❌ BossCraft module not found in /mnt/extra-addons/"
    echo "Available addons:"
    ls -la /mnt/extra-addons/ || echo "No extra addons directory"
fi

# 测试数据库连接（如果可能）
echo "=== Testing Database Connection ==="
if command -v pg_isready > /dev/null 2>&1; then
    if pg_isready -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER" > /dev/null 2>&1; then
        echo "✅ Database is ready!"
    else
        echo "⚠️  Database connection test failed, but continuing..."
    fi
else
    echo "ℹ️  pg_isready not available, skipping connection test"
fi

echo "=== Starting Odoo Server ==="
echo "Command: odoo $@"
echo "=========================================="

# 启动Odoo
exec odoo "$@"
