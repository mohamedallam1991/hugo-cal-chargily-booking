---
title: "Payment Successful"
layout: "single"
description: "Your booking payment has been processed successfully"
---

{{ $config := site.Data.cal_config }}
{{ $ui := $config.ui }}

# 🎉 {{ $ui.success_page.title }}

{{ $ui.success_page.message }}

## 📋 Booking Details

<div class="booking-confirmation bg-green-50 border border-green-200 rounded-lg p-6 my-6">
  <div class="space-y-4">
    <div class="flex items-center space-x-3">
      <div class="bg-green-100 rounded-full p-2">
        <svg class="w-6 h-6 text-green-600" fill="currentColor" viewBox="0 0 20 20">
          <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
        </svg>
      </div>
      <div>
        <h3 class="text-lg font-semibold text-green-800">Payment Confirmed</h3>
        <p class="text-green-600">Your transaction was processed successfully</p>
      </div>
    </div>

    <div class="grid md:grid-cols-2 gap-4">
      <div>
        <h4 class="font-medium text-gray-700 mb-2">Payment Information</h4>
        <dl class="space-y-1 text-sm">
          <div class="flex justify-between">
            <dt class="text-gray-600">Payment ID:</dt>
            <dd class="font-mono" id="paymentId">Loading...</dd>
          </div>
          <div class="flex justify-between">
            <dt class="text-gray-600">Amount Paid:</dt>
            <dd class="font-medium" id="paymentAmount">Loading...</dd>
          </div>
          <div class="flex justify-between">
            <dt class="text-gray-600">Payment Method:</dt>
            <dd id="paymentMethod">Chargily</dd>
          </div>
          <div class="flex justify-between">
            <dt class="text-gray-600">Status:</dt>
            <dd class="text-green-600 font-medium">Completed</dd>
          </div>
        </dl>
      </div>

      <div>
        <h4 class="font-medium text-gray-700 mb-2">Booking Information</h4>
        <dl class="space-y-1 text-sm">
          <div class="flex justify-between">
            <dt class="text-gray-600">Booking ID:</dt>
            <dd class="font-mono" id="bookingId">Loading...</dd>
          </div>
          <div class="flex justify-between">
            <dt class="text-gray-600">Service:</dt>
            <dd id="eventType">Loading...</dd>
          </div>
          <div class="flex justify-between">
            <dt class="text-gray-600">Date & Time:</dt>
            <dd id="bookingDateTime">Loading...</dd>
          </div>
          <div class="flex justify-between">
            <dt class="text-gray-600">Confirmation Email:</dt>
            <dd class="text-green-600">Sent</dd>
          </div>
        </dl>
      </div>
    </div>

  </div>
</div>

## 📧 What's Next?

1. **Check Your Email**: You'll receive a detailed confirmation email with:
   - Meeting link (if virtual)
   - Calendar invitation
   - Preparation instructions
   - Contact information

2. **Add to Calendar**: Click the link in your email to add the meeting to your calendar.

3. **Prepare for Your Session**: Review any preparation materials sent in the confirmation email.

## 📅 {{ $ui.success_page.calendar_title }}

<div class="bg-blue-50 border border-blue-200 rounded-lg p-6 my-6">
  <h3 class="text-lg font-semibold text-blue-800 mb-3">📅 Add to Your Calendar</h3>
  <p class="text-blue-600 mb-4">Never miss your appointment by adding it to your preferred calendar:</p>

  <div class="flex flex-wrap gap-3">
    <button onclick="addToGoogleCalendar()" class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 px-4 py-2 rounded-lg flex items-center space-x-2">
      <svg class="w-5 h-5" viewBox="0 0 24 24">
        <path fill="#4285F4" d="M..."/>
      </svg>
      <span>Google Calendar</span>
    </button>

    <button onclick="addToOutlookCalendar()" class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 px-4 py-2 rounded-lg flex items-center space-x-2">
      <svg class="w-5 h-5" viewBox="0 0 24 24">
        <path fill="#0078D4" d="M..."/>
      </svg>
      <span>Outlook</span>
    </button>

    <button onclick="downloadCalendarFile()" class="bg-white hover:bg-gray-50 border border-gray-300 text-gray-700 px-4 py-2 rounded-lg flex items-center space-x-2">
      <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
        <path d="M3 17a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm3.293-7.707a1 1 0 011.414 0L9 10.586V3a1 1 0 112 0v7.586l1.293-1.293a1 1 0 111.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z"/>
      </svg>
      <span>Download .ics</span>
    </button>

  </div>
</div>

## 🤝 Need Help?

If you have any questions or need to reschedule, please don't hesitate to contact us:

- **Email**: {{ $config.email.support_email }}
- **Phone**: +213 XXX XXX XXX
- **Live Chat**: Available on our website

## 🔄 Reschedule or Cancel

Life happens! If you need to make changes to your appointment:

1. **Use the link in your confirmation email** to manage your booking
2. **Contact us at least 24 hours in advance** for rescheduling
3. **Check our cancellation policy** in the terms and conditions

## 📱 Stay Connected

Follow us for updates and tips:

- [Twitter](https://twitter.com/your-handle)
- [LinkedIn](https://linkedin.com/company/your-company)
- [Facebook](https://facebook.com/your-page)

---

<div class="text-center mt-8">
  <a href="/" class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-6 rounded-lg inline-block">
    ← Back to Home
  </a>
</div>

<script>
// Load payment and booking details from URL parameters
document.addEventListener('DOMContentLoaded', function() {
  const urlParams = new URLSearchParams(window.location.search);
  const paymentId = urlParams.get('payment_id');
  const bookingId = urlParams.get('booking_id');

  // Update page with payment details
  if (paymentId) {
    document.getElementById('paymentId').textContent = paymentId;
  }

  if (bookingId) {
    document.getElementById('bookingId').textContent = bookingId;
  }

  // Load additional details from API or localStorage
  loadBookingDetails();
});

async function loadBookingDetails() {
  try {
    // Get payment ID from URL
    const urlParams = new URLSearchParams(window.location.search);
    const paymentId = urlParams.get('payment_id');

    if (!paymentId) return;

    // Fetch payment details from your API
    const response = await fetch(`/api/payment-details/${paymentId}`);

    if (response.ok) {
      const data = await response.json();

      // Update page with fetched data
      if (data.amount && data.currency) {
        document.getElementById('paymentAmount').textContent =
          `${(data.amount / 100).toFixed(2)} ${data.currency}`;
      }

      if (data.metadata) {
        const metadata = data.metadata;
        document.getElementById('eventType').textContent = metadata.event_type || 'Consultation';

        if (metadata.slot_start) {
          const date = new Date(metadata.slot_start);
          document.getElementById('bookingDateTime').textContent =
            date.toLocaleString('en-US', {
              weekday: 'long',
              year: 'numeric',
              month: 'long',
              day: 'numeric',
              hour: '2-digit',
              minute: '2-digit'
            });
        }
      }
    }
  } catch (error) {
    console.error('Error loading booking details:', error);
  }
}

function addToGoogleCalendar() {
  // Implementation for Google Calendar integration
  const urlParams = new URLSearchParams(window.location.search);
  const bookingId = urlParams.get('booking_id');

  // Create Google Calendar URL
  const calendarUrl = `https://calendar.google.com/calendar/render?action=TEMPLATE&text=Consultation&details=Booking ID: ${bookingId}`;
  window.open(calendarUrl, '_blank');
}

function addToOutlookCalendar() {
  // Implementation for Outlook Calendar integration
  const urlParams = new URLSearchParams(window.location.search);
  const bookingId = urlParams.get('booking_id');

  // Create Outlook Calendar URL
  const calendarUrl = `https://outlook.live.com/calendar/0/deeplink/compose?subject=Consultation&body=Booking ID: ${bookingId}`;
  window.open(calendarUrl, '_blank');
}

function downloadCalendarFile() {
  // Implementation for downloading .ics file
  const urlParams = new URLSearchParams(window.location.search);
  const bookingId = urlParams.get('booking_id');

  // Generate and download .ics file
  const icsContent = `BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Your Company//Your Product//EN
BEGIN:VEVENT
UID:${bookingId}@your-domain.com
DTSTAMP:${new Date().toISOString().replace(/[-:]/g, '').split('.')[0]}Z
DTSTART:${new Date().toISOString().replace(/[-:]/g, '').split('.')[0]}Z
SUMMARY:Consultation Call
DESCRIPTION:Booking ID: ${bookingId}
END:VEVENT
END:VCALENDAR`;

  const blob = new Blob([icsContent], { type: 'text/calendar' });
  const url = window.URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = 'booking.ics';
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  window.URL.revokeObjectURL(url);
}
</script>

<style>
.booking-confirmation {
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

.calendar-button {
  transition: all 0.2s ease;
}

.calendar-button:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
</style>
