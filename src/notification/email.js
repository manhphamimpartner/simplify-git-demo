'use strict';

// Email Notification
function buildEmailTemplate(type, data) {
  const templates = {
    welcome: `Chào ${data.name}! Cảm ơn bạn đã đăng ký.`,
    reset:   `Nhấn link để đặt lại mật khẩu: ${data.link}`,
    alert:   `Thông báo quan trọng: ${data.message}`,
  };
  if (!templates[type]) throw new Error(`Unknown template: ${type}`);
  return templates[type];
}

function sendEmail(to, subject, body) {
  if (!to) throw new Error('Recipient is required');
  return { to, subject, body, status: 'queued' };
}

module.exports = { buildEmailTemplate, sendEmail };
