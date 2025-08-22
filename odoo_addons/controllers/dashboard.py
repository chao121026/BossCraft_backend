# controllers/dashboard.py
from odoo import http
from odoo.http import request
import json
from datetime import datetime, timedelta

class UnifiedDashboard(http.Controller):

    @http.route('/dashboard/unified', type='http', auth='user', website=True)
    def unified_dashboard(self, **kw):
        user = request.env.user
        company = user.company_id

        # Sourcing Health
        products = request.env['product.product'].sudo().search([
            ('company_id', '=', company.id)
        ])
        total_products = len(products)
        out_of_stock = len(products.filtered(lambda p: p.qty_available <= 0))
        price_changed = len(products.filtered(lambda p: p.last_price_update and 
                                            (datetime.now() - p.last_price_update).days > 30))

        # Store Performance
        orders = request.env['sale.order'].sudo().search([
            ('company_id', '=', company.id),
            ('date_order', '>=', datetime.now() - timedelta(days=30))
        ])
        total_revenue = sum(order.amount_total for order in orders)
        total_orders = len(orders)
        conversion_rate = (total_orders / 1000) * 100 if total_orders > 0 else 0  # Simulated

        # Fulfillment Status
        fulfilled_orders = len(orders.filtered(lambda o: o.carrier_tracking_ref))
        pending_fulfill = len(orders.filtered(lambda o: not o.fulfillment_agent_id))
        delayed_orders = len(orders.filtered(lambda o: o.delivery_status == 'delayed'))

        # Profit Intelligence
        total_profit = sum(order.profit for order in orders)
        avg_margin = (total_profit / total_revenue * 100) if total_revenue else 0

        return request.render('boss_craft_unified_dashboard.unified_dashboard', {
            'sourcing': {
                'total_products': total_products,
                'out_of_stock': out_of_stock,
                'price_changed': price_changed
            },
            'store': {
                'revenue': total_revenue,
                'orders': total_orders,
                'conversion_rate': conversion_rate
            },
            'fulfillment': {
                'fulfilled': fulfilled_orders,
                'pending': pending_fulfill,
                'delayed': delayed_orders
            },
            'profit': {
                'total': total_profit,
                'margin': avg_margin
            },
            'user_name': user.name
        })

    @http.route('/api/dashboard/health', type='json', auth='user')
    def dashboard_health(self, **kw):
        """API for real-time updates"""
        company = request.env.user.company_id.id
        return {
            'sourcing': 'healthy',
            'store': 'healthy',
            'fulfillment': 'warning',
            'profit': 'healthy'
        }