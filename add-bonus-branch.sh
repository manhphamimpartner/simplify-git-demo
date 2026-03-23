#!/bin/bash
# ============================================================
# Chạy script này trong thư mục simplify-git-demo đã có sẵn
# để thêm branch demo/bonus
# ============================================================
set -e

echo "➕ Adding demo/bonus branch..."

git checkout main

# Nếu branch đã tồn tại thì xóa và tạo lại
git branch -D demo/bonus 2>/dev/null || true
git checkout -b demo/bonus
mkdir -p src/notification

# ── Commit 1: sạch ──────────────────────────────────────────
cat > src/notification/notification.js << 'EOF'
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
EOF
git add . && git commit -m "feat(notification): add notification module"

# ── Commit 2: DEBUG — cần DROP ──────────────────────────────
cat >> src/notification/notification.js << 'EOF'

// DEBUG - xóa trước khi PR
function _debug() {
  console.log('[DEBUG] subscribers:', JSON.stringify(subscribers, null, 2));
  console.log('[DEBUG] total:', subscribers.length);
}
EOF
git add . && git commit -m "debug: log notification payload"

# ── Commit 3: sạch ──────────────────────────────────────────
cat > src/notification/email.js << 'EOF'
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

module.exports = { buildEmailTemplate };
EOF
git add . && git commit -m "feat(notification): add email template"

# ── Commit 4: wip — cần FIXUP ───────────────────────────────
cat >> src/notification/email.js << 'EOF'

function sendEmail(to, subject, body) {
  // TODO: integrate sendgrid
  console.log('send email', to, subject)
  return { to, subject, body, sent: false }
}
EOF
git add . && git commit -m "wip email"

# ── Commit 5: fix lint — cần FIXUP ──────────────────────────
cat > src/notification/email.js << 'EOF'
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
EOF
git add . && git commit -m "fix lint"

# ── Commit 6: nhét 3 việc vào 1 — cần EDIT/tách ─────────────
# [việc 1] feat: push notification
cat > src/notification/push.js << 'EOF'
// Push Notification
const FCM_KEY = process.env.FCM_SERVER_KEY;

function sendPush(deviceToken, title, body) {
  if (!deviceToken) throw new Error('deviceToken is required');
  if (!FCM_KEY) throw new Error('FCM_SERVER_KEY not configured');
  return { to: deviceToken, notification: { title, body }, status: 'sent' };
}

module.exports = { sendPush };
EOF
# [việc 2] fix: payment currency validation
cat > src/payment/payment.js << 'EOF'
'use strict';

const VALID_CURRENCIES = ['VND', 'USD', 'EUR', 'SGD'];

function createPayment(amount, currency) {
  if (!amount || amount <= 0) throw new Error('Amount must be positive');
  if (!currency) throw new Error('Currency is required');
  if (!VALID_CURRENCIES.includes(currency)) {
    throw new Error(`Invalid currency. Accepted: ${VALID_CURRENCIES.join(', ')}`);
  }
  return { id: `pay_${Date.now()}`, amount, currency, status: 'pending' };
}

function getPayment(id) {
  if (!id) throw new Error('Payment ID is required');
  return { id, status: 'completed' };
}

module.exports = { createPayment, getPayment };
EOF
# [việc 3] chore: bump package version
cat > package.json << 'EOF'
{
  "name": "simplify-git-demo",
  "version": "1.2.0",
  "description": "Demo project for clean git history talk",
  "scripts": {
    "start": "node src/index.js",
    "test": "jest",
    "lint": "eslint src/"
  },
  "engines": { "node": ">=16" }
}
EOF
git add . && git commit -m "update notification + config + fix payment"

# ── Commit 7: almost done — cần FIXUP ───────────────────────
cat > src/notification/index.js << 'EOF'
'use strict';

const { subscribe, unsubscribe, getSubscribers } = require('./notification');
const { buildEmailTemplate, sendEmail } = require('./email');
const { sendPush } = require('./push');

module.exports = { subscribe, unsubscribe, getSubscribers, buildEmailTemplate, sendEmail, sendPush };
EOF
git add . && git commit -m "almost done"

# ── Commit 8: console.log — cần DROP ────────────────────────
cat >> src/notification/push.js << 'EOF'

// REMOVE BEFORE MERGE
console.log('push.js loaded, FCM_KEY:', FCM_KEY ? 'SET' : 'NOT SET');
EOF
git add . && git commit -m "console.log remove this"

# ── Commit 9: sạch ──────────────────────────────────────────
cat >> src/notification/index.js << 'EOF'

const { createPayment, getPayment } = require('../payment/payment');
module.exports.createPayment = createPayment;
module.exports.getPayment    = getPayment;
EOF
git add . && git commit -m "chore: re-export payment from notification index"

git checkout main

echo ""
echo "✅ demo/bonus created:"
git log demo/bonus --oneline
echo ""
echo "👉 Push lên GitHub:"
echo "   git push origin demo/bonus"
