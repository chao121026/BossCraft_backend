# Use the official Odoo 17 image as the base
FROM odoo:17.0

# Set the working directory (optional, but good practice)
WORKDIR /opt/odoo

# Copy your entire odoo_addons folder to /mnt/extra-addons
# This is the path Odoo expects for extra modules
COPY odoo_addons /mnt/extra-addons

# Copy the Odoo configuration file to the standard location
COPY odoo.conf /etc/odoo/odoo.conf

# Expose the Odoo HTTP port
EXPOSE 8069

# The CMD is already defined in the base image, but we can override it to add automation
# --init: Automatically install the specified module when a new database is created
# --load: Ensure the web module is loaded
# --workers: Set the number of worker processes
CMD ["odoo", "--init=boss_craft_unified_dashboard", "--load=web", "--workers=4"]