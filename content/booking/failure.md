---
title: "Payment Failed"
layout: "single"
description: "Your payment could not be processed"
---

{{ $config := site.Data.cal_config }}
{{ $ui := $config.ui }}

# ❌ {{ $ui.failure_page.title }}

{{ $ui.failure_page.message }}

## 📋 Payment Details

<div class="payment-failure bg-red-50 border border-red-200 rounded-lg p-6 my-6">
  <div class="space-y-4">
    <div class="flex items-center space-x-3">
      <div class="bg-red-100 rounded-full p-2">
        <svg class="w-6 h-6 text-red-600" fill="currentColor" viewBox="0 0 20 20">
          <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"/>
        </svg>
      </div>
      <div>
        <h3 class="text-lg font-semibold text-red-800">Payment Declined</h3>
        <p class="text-red-600">Your transaction could not be completed</p>
      </div>
    </div>

    <div class="bg-white border border-red-200 rounded-lg p-4">
      <h4 class="font-medium text-gray-700 mb-2">Transaction Information</h4>
      <dl class="space-y-1 text-sm">
        <div class="flex justify-between">
          <dt class="text-gray-600">Payment ID:</dt>
          <dd class="font-mono" id="paymentId">Loading...</dd>
        </div>
        <div class="flex justify-between">
          <dt class="text-gray-600">Attempted Amount:</dt>
          <dd class="font-medium" id="paymentAmount">Loading...</dd>
        </div>
        <div class="flex justify-between">
          <dt class="text-gray-600">Payment Method:</dt>
          <dd id="paymentMethod">Chargily</dd>
        </div>
        <div class="flex justify-between">
          <dt class="text-gray-600">Status:</dt>
          <dd class="text-red-600 font-medium">Failed</dd>
        </div>
        <div class="flex justify-between">
          <dt class="text-gray-600">Time:</dt>
          <dd id="failureTime">Loading...</dd>
        </div>
      </dl>
    </div>

  </div>
</div>

## 🔍 Common Reasons for Payment Failure

<div class="grid md:grid-cols-2 gap-4 my-6">
  <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
    <h4 class="font-medium text-yellow-800 mb-2">💳 Card Issues</h4>
    <ul class="text-sm text-yellow-700 space-y-1">
      <li>• Insufficient funds</li>
      <li>• Card expired or blocked</li>
      <li>• Incorrect card details</li>
      <li>• Daily transaction limit reached</li>
    </ul>
  </div>

  <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
    <h4 class="font-medium text-yellow-800 mb-2">🌐 Technical Issues</h4>
    <ul class="text-sm text-yellow-700 space-y-1">
      <li>• Network connectivity problems</li>
      <li>• Bank server maintenance</li>
      <li>• Payment gateway timeout</li>
      <li>• 3D Secure authentication failed</li>
    </ul>
  </div>
</div>

## 🔄 What You Can Do

### Option 1: Try Again

<div class="bg-blue-50 border border-blue-200 rounded-lg p-6 my-6">
  <h3 class="text-lg font-semibold text-blue-800 mb-3">🔄 Retry Your Payment</h3>
  <p class="text-blue-600 mb-4">Sometimes a simple retry is all that's needed:</p>

  <button onclick="retryPayment()" class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-6 rounded-lg inline-block">
    Try Payment Again
  </button>
</div>

### Option 2: Use Different Payment Method

<div class="bg-green-50 border border-green-200 rounded-lg p-6 my-6">
  <h3 class="text-lg font-semibold text-green-800 mb-3">💳 Try Different Payment Method</h3>
  <p class="text-green-600 mb-4">Chargily supports multiple payment options:</p>

  <div class="grid grid-cols-3 gap-3">
    <div class="text-center p-3 border border-green-200 rounded-lg bg-white">
      <div class="text-2xl mb-2">💳</div>
      <div class="text-sm font-medium">Credit/Debit Card</div>
    </div>
    <div class="text-center p-3 border border-green-200 rounded-lg bg-white">
      <div class="text-2xl mb-2">📱</div>
      <div class="text-sm font-medium">Edahabia</div>
    </div>
    <div class="text-center p-3 border border-green-200 rounded-lg bg-white">
      <div class="text-2xl mb-2">🏦</div>
      <div class="text-sm font-medium">CIB</div>
    </div>
  </div>

  <button onclick="chooseDifferentMethod()" class="bg-green-600 hover:bg-green-700 text-white font-semibold py-2 px-6 rounded-lg inline-block mt-4">
    Choose Different Method
  </button>
</div>

### Option 3: Contact Support

<div class="bg-purple-50 border border-purple-200 rounded-lg p-6 my-6">
  <h3 class="text-lg font-semibold text-purple-800 mb-3">🤝 Get Help from Our Team</h3>
  <p class="text-purple-600 mb-4">If you continue to experience issues, we're here to help:</p>

  <div class="space-y-3">
    <a href="mailto:{{ $config.email.support_email }}" class="flex items-center space-x-3 text-purple-700 hover:text-purple-900">
      <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
        <path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z"/>
        <path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z"/>
      </svg>
      <span>{{ $config.email.support_email }}</span>
    </a>

    <a href="tel:+213XXXXXXXXX" class="flex items-center space-x-3 text-purple-700 hover:text-purple-900">
      <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
        <path d="M2 3a1 1 0 011-1h2.153a1 1 0 01.986.836l.74 4.435a1 1 0 01-.54 1.06l-1.548.773a11.037 11.037 0 006.105 6.105l.774-1.548a1 1 0 011.059-.54l4.435.74a1 1 0 01.836.986V17a1 1 0 01-1 1h-2C7.82 18 2 12.18 2 5V3z"/>
      </svg>
      <span>+213 XXX XXX XXX</span>
    </a>

    <button onclick="startLiveChat()" class="flex items-center space-x-3 text-purple-700 hover:text-purple-900">
      <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
        <path fill-rule="evenodd" d="M18 10c0 3.866-3.582 7-8 7a8.841 8.841 0 01-4.083-.98L2 17l1.338-3.123C2.493 12.767 2 11.434 2 10c0-3.866 3.582-7 8-7s8 3.134 8 7zM7 9H5v2h2V9zm8 0h-2v2h2V9zM9 9h2v2H9V9z" clip-rule="evenodd"/>
      </svg>
      <span>Start Live Chat</span>
    </button>

  </div>
</div>

## 📝 Troubleshooting Tips

### Before Trying Again:

1. **Check your card balance** - Ensure sufficient funds are available
2. **Verify card details** - Double-check card number, expiry date, and CVV
3. **Try a different browser** - Clear cache and cookies or use incognito mode
4. **Check with your bank** - Ensure no blocks are placed on online transactions

### Security Reminder:

- We'll never ask for your full card details via email or phone
- Always ensure you're on our official website (check the URL)
- If something seems suspicious, contact us immediately

## 🔄 Booking Status

<div class="bg-gray-50 border border-gray-200 rounded-lg p-6 my-6">
  <h3 class="text-lg font-semibold text-gray-800 mb-3">📅 Your Booking Status</h3>
  <p class="text-gray-600 mb-4">
    Your <strong>booking time slot is currently reserved</strong> for 15 minutes.
    If you don't complete the payment within this time, the slot will be released for others.
  </p>

  <div class="bg-yellow-100 border border-yellow-300 rounded-lg p-3">
    <p class="text-sm text-yellow-800">
      <strong>⏰ Time remaining:</strong>
      <span id="timeRemaining">15:00</span>
    </p>
  </div>
</div>

---

<div class="text-center mt-8 space-x-4">
  <a href="/" class="bg-gray-600 hover:bg-gray-700 text-white font-semibold py-2 px-6 rounded-lg inline-block">
    ← Back to Home
  </a>

  <button onclick="window.print()" class="bg-gray-200 hover:bg-gray-300 text-gray-700 font-semibold py-2 px-6 rounded-lg inline-block">
    🖨️ Print This Page
  </button>
</div>

<script>
// Load payment details from URL parameters
document.addEventListener('DOMContentLoaded', function() {
  const urlParams = new URLSearchParams(window.location.search);
  const paymentId = urlParams.get('payment_id');
  const error = urlParams.get('error');

  // Update page with payment details
  if (paymentId) {
    document.getElementById('paymentId').textContent = paymentId;
  }

  // Set current time
  document.getElementById('failureTime').textContent = new Date().toLocaleString();

  // Load additional details
  loadPaymentDetails();

  // Start countdown timer
  startCountdown();
});

async function loadPaymentDetails() {
  try {
    const urlParams = new URLSearchParams(window.location.search);
    const paymentId = urlParams.get('payment_id');

    if (!paymentId) return;

    // Fetch payment details from your API
    const response = await fetch(`/api/payment-details/${paymentId}`);

    if (response.ok) {
      const data = await response.json();

      if (data.amount && data.currency) {
        document.getElementById('paymentAmount').textContent =
          `${(data.amount / 100).toFixed(2)} ${data.currency}`;
      }
    }
  } catch (error) {
    console.error('Error loading payment details:', error);
  }
}

function retryPayment() {
  // Redirect back to booking page to retry payment
  const urlParams = new URLSearchParams(window.location.search);
  const bookingId = urlParams.get('booking_id');

  if (bookingId) {
    window.location.href = `/book?booking_id=${bookingId}&retry=true`;
  } else {
    window.location.href = '/book';
  }
}

function chooseDifferentMethod() {
  // Redirect to booking page with different payment method option
  const urlParams = new URLSearchParams(window.location.search);
  const bookingId = urlParams.get('booking_id');

  if (bookingId) {
    window.location.href = `/book?booking_id=${bookingId}&change_payment=true`;
  } else {
    window.location.href = '/book';
  }
}

function startLiveChat() {
  // Implement live chat integration
  window.open('https://your-chat-service.com/chat', '_blank');
}

let countdownInterval;
function startCountdown() {
  let timeLeft = 15 * 60; // 15 minutes in seconds

  countdownInterval = setInterval(function() {
    const minutes = Math.floor(timeLeft / 60);
    const seconds = timeLeft % 60;

    document.getElementById('timeRemaining').textContent =
      `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;

    if (timeLeft <= 0) {
      clearInterval(countdownInterval);
      document.getElementById('timeRemaining').textContent = 'Expired';

      // Show expired message
      const statusDiv = document.querySelector('.bg-gray-50');
      statusDiv.innerHTML = `
        <div class="bg-red-100 border border-red-300 rounded-lg p-3">
          <p class="text-sm text-red-800">
            <strong>⏰ Time expired:</strong>
            Your booking slot has been released. Please select a new time slot.
          </p>
        </div>
        <button onclick="window.location.href='/book'" class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-6 rounded-lg mt-4">
          Select New Time Slot
        </button>
      `;
    }

    timeLeft--;
  }, 1000);
}

// Cleanup countdown when page is unloaded
window.addEventListener('beforeunload', function() {
  if (countdownInterval) {
    clearInterval(countdownInterval);
  }
});
</script>

<style>
.payment-failure {
  animation: slideInUp 0.5s ease-out;
}

@keyframes slideInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.payment-option {
  transition: all 0.2s ease;
}

.payment-option:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.countdown-warning {
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.7;
  }
}
</style>
