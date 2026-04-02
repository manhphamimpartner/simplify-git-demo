'use strict';

// Payment History Service
const payments = [];

function addPayment(payment) {
  if (!payment.userId) throw new Error('userId is required');
  if (!payment.amount) throw new Error('amount is required');
  payments.push({ ...payment, createdAt: new Date().toISOString() });
}

function getHistory(userId) {
  if (!userId) throw new Error('userId is required');
  return payments.filter((p) => p.userId === userId);
}

function getTotalSpent(userId) {
  const history = getHistory(userId);
  return history.reduce((sum, p) => sum + p.amount, 0);
}

module.exports = { addPayment, getHistory, getTotalSpent };

function clearHistory(userId) {
  const indices = payments
    .map((p, i) => (p.userId === userId ? i : -1))
    .filter((i) => i !== -1)
    .reverse();
  indices.forEach((i) => payments.splice(i, 1));
  return indices.length;
}
