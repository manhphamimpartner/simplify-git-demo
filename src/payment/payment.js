// Payment Service
function createPayment(amount, currency) {
  if (amount <= 0) throw new Error('Amount must be positive');
  return { id: 'pay_001', amount, currency, status: 'pending' };
}

module.exports = { createPayment };
