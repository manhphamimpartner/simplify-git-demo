// Push Notification
const FCM_KEY = process.env.FCM_SERVER_KEY;

function sendPush(deviceToken, title, body) {
  if (!deviceToken) throw new Error('deviceToken is required');
  if (!FCM_KEY) throw new Error('FCM_SERVER_KEY not configured');
  return { to: deviceToken, notification: { title, body }, status: 'sent' };
}

module.exports = { sendPush };
