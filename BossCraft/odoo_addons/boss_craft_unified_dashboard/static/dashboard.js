// static/dashboard.js
document.addEventListener('DOMContentLoaded', () => {
  // Revenue Chart
  const revenueCtx = document.getElementById('revenueChart').getContext('2d');
  new Chart(revenueCtx, {
    type: 'line',
    data: {
      labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
      datasets: [{
        label: 'Revenue',
        data: [12000, 19000, 15000, 25000, 22000, 30000, 28000],
        borderColor: '#10b981',
        backgroundColor: 'rgba(16, 185, 129, 0.1)',
        tension: 0.4
      }]
    },
    options: {
      responsive: true,
      plugins: {
        legend: { display: false }
      }
    }
  });

  // Profit Chart
  const profitCtx = document.getElementById('profitChart').getContext('2d');
  new Chart(profitCtx, {
    type: 'doughnut',
    data: {
      labels: ['Product Cost', 'Shipping', 'Duty', 'Payment Fee', 'Profit'],
      datasets: [{
        data: [40, 20, 10, 5, 25],
        backgroundColor: [
          '#6b7280',
          '#06b6d4',
          '#f59e0b',
          '#8b5cf6',
          '#10b981'
        ]
      }]
    },
    options: {
      responsive: true,
      plugins: {
        legend: { position: 'right' }
      }
    }
  });

  // Real-time updates
  function pollDashboard() {
    fetch('/api/dashboard/health')
      .then(r => r.json())
      .then(data => {
        console.log('Dashboard health:', data);
      })
      .catch(err => console.error('Poll error:', err))
      .finally(() => {
        setTimeout(pollDashboard, 60000); // Every minute
      });
  }

  pollDashboard();

  window.fetchFulfillmentQuotes = function() {
    alert('Fetching shipping quotes from YunExpress, CJ, and LYG...');
    // In prod: call /api/shipping/quotes
  };
});