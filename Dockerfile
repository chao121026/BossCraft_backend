FROM odoo:17.0

# 复制插件目录并直接设置权限（使用 --chown 参数）
COPY --chown=odoo:odoo odoo_addons /mnt/extra-addons

# 复制配置模板和启动脚本
COPY odoo.conf /etc/odoo/odoo.conf.template
COPY start.sh /start.sh

# 安装 envsubst 并设置脚本权限
USER root
RUN apt-get update && apt-get install -y gettext-base && \
    chmod +x /start.sh
USER odoo

# 调试：列出添加的模块
RUN echo "Available addons:" && \
    ls -la /mnt/extra-addons/ 2>/dev/null || echo "No addons directory"

# 设置启动脚本为入口点
ENTRYPOINT ["/start.sh"]

EXPOSE 8069
CMD ["odoo", "--init=boss_craft_unified_dashboard", "--load=web", "--workers=4"]
