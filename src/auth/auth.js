// Auth Service
const { createRefreshToken, revokeRefreshToken } = require('./refresh');

function login(username, password) {
  if (!username || !password) {
    throw new Error('Username and password are required');
  }
  const refreshToken = createRefreshToken(username);
  return { token: 'jwt_token', refreshToken, user: username };
}

function logout(token, refreshToken) {
  if (refreshToken) revokeRefreshToken(refreshToken);
  return true;
}

module.exports = { login, logout };
