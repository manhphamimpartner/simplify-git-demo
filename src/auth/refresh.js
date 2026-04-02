// Refresh Token  [việc 1 — feat]
const sessions = new Map();

function createRefreshToken(userId) {
  const token = `refresh_${userId}_${Date.now()}`;
  sessions.set(token, { userId, createdAt: Date.now() });
  return token;
}

function validateRefreshToken(token) {
  return sessions.has(token);
}

function revokeRefreshToken(token) {
  return sessions.delete(token);
}

module.exports = { createRefreshToken, validateRefreshToken, revokeRefreshToken };
