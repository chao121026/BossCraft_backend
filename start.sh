#!/bin/bash

# 使用 envsubst 命令来替换模板文件中的环境变量
# 然后将输出写入到 Odoo 的实际配置文件中
envsubst < /etc/odoo/odoo.conf.template > /etc/odoo/odoo.conf

# 执行原始的 Docker CMD，启动 Odoo
exec "$@"
