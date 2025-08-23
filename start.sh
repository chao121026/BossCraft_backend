#!/bin/bash

# 调试：输出所有环境变量
echo "=== 环境变量 ==="
env | grep -E "(DB_|PG)" || echo "没有找到数据库变量"
echo "================"

# 测试数据库连接
echo "测试数据库连接..."
if command -v psql &> /dev/null; then
    export PGPASSWORD=$DB_PASSWORD
    if psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "SELECT version();"; then
        echo "✅ 数据库连接成功!"
    else
        echo "❌ 数据库连接失败!"
        echo "连接参数:"
        echo "Host: $DB_HOST"
        echo "Port: $DB_PORT" 
        echo "User: $DB_USER"
        echo "Database: $DB_NAME"
    fi
else
    echo "psql 不可用，跳过连接测试"
fi

# 生成配置文件
echo "生成 Odoo 配置文件..."
envsubst < /etc/odoo/odoo.conf.template > /etc/odoo/odoo.conf

echo "=== 生成的配置 ==="
head -15 /etc/odoo/odoo.conf
echo "================"

# 启动 Odoo
echo "启动 Odoo 服务..."
exec "$@"
