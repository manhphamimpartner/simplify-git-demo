'use strict';

const VALID_CURRENCIES = ['VND', 'USD', 'EUR', 'SGD'];

function createPayment(amount, currency) {
  if (!amount || amount <= 0) throw new Error('Amount must be positive');
  if (!currency) throw new Error('Currency is required');
  if (!VALID_CURRENCIES.includes(currency)) {
    throw new Error(`Invalid currency. Accepted: ${VALID_CURRENCIES.join(', ')}`);
  }
  return { id: `pay_${Date.now()}`, amount, currency, status: 'pending' };
}

function getPayment(id) {
  if (!id) throw new Error('Payment ID is required');
  return { id, status: 'completed' };
}

module.exports = { createPayment, getPayment };
