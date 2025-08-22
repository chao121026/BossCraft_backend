# models/unified_dashboard.py
from odoo import models, fields

class UnifiedDashboard(models.Model):
    _name = 'unified.dashboard'
    _description = 'Unified E-Commerce Dashboard'

    name = fields.Char(string='Dashboard Name', default='BossCraft Dashboard')
    company_id = fields.Many2one('res.company', string='Company')
    # You can add computed fields here for dashboard metrics
    # e.g., total_products, total_revenue, etc.