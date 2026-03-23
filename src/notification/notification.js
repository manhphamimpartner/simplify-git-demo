// Notification Service
const subscribers = [];

function subscribe(userId, channel) {
  if (!userId) throw new Error('userId is required');
  if (!channel) throw new Error('channel is required');
  subscribers.push({ userId, channel, createdAt: new Date().toISOString() });
  return true;
}

function unsubscribe(userId) {
  const idx = subscribers.findIndex((s) => s.userId === userId);
  if (idx === -1) return false;
  subscribers.splice(idx, 1);
  return true;
}

function getSubscribers(channel) {
  return subscribers.filter((s) => s.channel === channel);
}

module.exports = { subscribe, unsubscribe, getSubscribers };
