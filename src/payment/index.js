const { createPayment, getPayment } = require('./payment');
const { addPayment, getHistory, getTotalSpent, clearHistory } = require('./history');

module.exports = {
  createPayment,
  getPayment,
  addPayment,
  getHistory,
  getTotalSpent,
  clearHistory,
};
