// User Service
function getUser(id) {
  return { id, name: 'John Doe', email: 'john@example.com' };
}

function updateUser(id, data) {
  return { id, ...data };
}

module.exports = { getUser, updateUser };
