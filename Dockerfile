FROM odoo:17.0
COPY odoo_addons /mnt/extra-addons
COPY odoo.conf /etc/odoo/odoo.conf
EXPOSE 8069
CMD ["odoo", "--init=boss_craft_unified_dashboard", "--load=web", "--workers=4"]