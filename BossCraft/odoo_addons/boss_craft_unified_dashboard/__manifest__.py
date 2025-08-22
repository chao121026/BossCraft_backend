{
    'name': 'BossCraft - Unified E-Commerce Dashboard',
    'version': '1.0',
    'summary': 'Single view for sourcing, store, fulfillment, and profit',
    'description': '''
        Unified dashboard showing supplier health, store performance, 
        fulfillment status, and real-time profit intelligence.
        The central command center for e-commerce merchants.
    ''',
    'category': 'Website',
    'author': 'BossCraft Team',
    'depends': [
        'web',
        'sale',
        'stock',
        'account',
        'website',
        # Add any other dependencies your module needs
    ],
    'data': [
        'templates/unified_dashboard.xml',
        # If you have security or data files, add them here
        # 'security/ir.model.access.csv',
    ],
    'assets': {
        'web.assets_frontend': [
            'boss_craft_unified_dashboard/static/dashboard.js',
            'boss_craft_unified_dashboard/static/dashboard.css',
        ],
    },
    'installable': True,
    'application': False,
    'auto_install': False,
}