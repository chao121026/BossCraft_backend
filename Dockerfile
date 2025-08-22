FROM odoo:17.0

# 复制插件目录
COPY odoo_addons /mnt/extra-addons

# 安全地设置权限（只在目录存在时执行）
RUN if [ -d "/mnt/extra-addons" ]; then \
    echo "Setting permissions for Odoo addons..." && \
    chown -R odoo:odoo /mnt/extra-addons && \
    chmod -R 755 /mnt/extra-addons && \
    echo "Permissions set successfully"; \
else \
    echo "Warning: /mnt/extra-addons directory does not exist"; \
fi

# 复制配置模板和启动脚本
COPY odoo.conf /etc/odoo/odoo.conf.template
COPY start.sh /start.sh

# 安装 envsubst 并设置脚本权限
RUN apt-get update && apt-get install -y gettext-base && \
    chmod +x /start.sh

# 调试：列出添加的模块
RUN echo "Available addons:" && \
    ls -la /mnt/extra-addons/ 2>/dev/null || echo "No addons directory"

# 设置启动脚本为入口点
ENTRYPOINT ["/start.sh"]

EXPOSE 8069
CMD ["odoo", "--init=boss_craft_unified_dashboard", "--load=web", "--workers=4"]
