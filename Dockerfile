FROM odoo:17.0

# 设置工作目录
WORKDIR /mnt/extra-addons

# 复制自定义插件（使用你当前的文件夹名）
COPY --chown=odoo:odoo odoo_addons /mnt/extra-addons

# 复制配置模板和启动脚本
COPY odoo.conf.template /etc/odoo/odoo.conf.template
COPY start.sh /start.sh

# 以root用户安装依赖并设置权限
USER root
RUN apt-get update && \
    apt-get install -y gettext-base && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +x /start.sh && \
    chown -R odoo:odoo /etc/odoo/

# 切换回odoo用户
USER odoo

# 验证插件安装
RUN echo "Available addons:" && \
    ls -la /mnt/extra-addons/ && \
    echo "Boss Craft module:" && \
    ls -la /mnt/extra-addons/boss_craft_unified_dashboard/ 2>/dev/null || echo "Module not found"

ENTRYPOINT ["/start.sh"]
EXPOSE 8069
CMD ["odoo", "--init=boss_craft_unified_dashboard", "--workers=4"]
