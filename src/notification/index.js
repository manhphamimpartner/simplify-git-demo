'use strict';

const { subscribe, unsubscribe, getSubscribers } = require('./notification');
const { buildEmailTemplate, sendEmail } = require('./email');
const { sendPush } = require('./push');

module.exports = { subscribe, unsubscribe, getSubscribers, buildEmailTemplate, sendEmail, sendPush };

const { createPayment, getPayment } = require('../payment/payment');
module.exports.createPayment = createPayment;
module.exports.getPayment    = getPayment;
