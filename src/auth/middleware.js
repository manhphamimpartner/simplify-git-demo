// Auth Middleware
function requireAuth(req) {
  if (!req.headers || !req.headers.authorization) {
    throw new Error('Unauthorized: missing token');
  }
  return true;
}

module.exports = { requireAuth };
