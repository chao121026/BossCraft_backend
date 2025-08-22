FROM odoo:17.0

# 复制插件并设置权限
COPY odoo_addons /mnt/extra-addons
RUN chown -R odoo:odoo /mnt/extra-addons && \
    chmod -R 755 /mnt/extra-addons

# 复制配置模板（注意后缀名 .template）
COPY odoo.conf /etc/odoo/odoo.conf.template
# 复制启动脚本
COPY start.sh /start.sh

# 安装 envsubst 命令（它通常在 gettext 包中）
RUN apt-get update && apt-get install -y gettext-base && \
    chmod +x /start.sh

# 设置启动脚本为入口点
ENTRYPOINT ["/start.sh"]

EXPOSE 8069
# 保持原来的 CMD，它会被入口点脚本的 `exec "$@"` 执行
CMD ["odoo", "--init=boss_craft_unified_dashboard", "--load=web", "--workers=4"]
