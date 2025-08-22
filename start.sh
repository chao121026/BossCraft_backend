#!/bin/bash

# 使用 envsubst 替换环境变量
envsubst < /etc/odoo/odoo.conf.template > /etc/odoo/odoo.conf

# 启动 Odoo
exec "$@"
