// Payment Service  [việc 2 — fix]
function createPayment(amount, currency) {
  if (!amount) throw new Error('Amount is required');
  if (amount <= 0) throw new Error('Amount must be positive');
  if (!currency) throw new Error('Currency is required');
  return { id: 'pay_001', amount, currency, status: 'pending' };
}

function getPayment(id) {
  if (!id) throw new Error('Payment ID is required');
  return { id, status: 'completed' };
}

module.exports = { createPayment, getPayment };
