// Auth Service
function login(username, password) {
  if (!username || !password) {
    throw new Error('Username and password are required');
  }
  return { token: 'jwt_token', user: username };
}

function logout(token) {
  return true;
}

module.exports = { login, logout };
