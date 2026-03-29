# Hugo Cal.com Chargily Booking Module

A production-ready, modular, configurable Cal.com booking system for Hugo static sites with **complete Chargily payment integration** for the Algerian market.

## 🚀 Features

- 🎯 **Multiple Booking Methods**: Embedded calendar, floating button, custom button
- 🔧 **Configuration-Driven**: Easy customization via YAML config
- 📱 **Responsive**: Works on all screen sizes
- 🎨 **Theme-Agnostic**: Compatible with any Hugo theme
- 🌍 **Multi-Language Ready**: Built-in i18n support
- 💳 **Complete Chargily Integration**: Full payment processing with Algerian payment methods
- 🔒 **Secure Payment Flow**: Webhook verification, signature validation
- 📧 **Automated Notifications**: Email confirmations and reminders
- 🛡️ **Production Ready**: Cloudflare deployment, error handling, monitoring

## 🎯 What's New in v2.0

- ✅ **Complete Chargily Payment Integration**
- ✅ **Secure Webhook Processing**
- ✅ **Production-Ready Deployment**
- ✅ **Enhanced Configuration System**
- ✅ **Mobile-Optimized Payment Flow**
- ✅ **Success/Failure Pages**
- ✅ **Email Notification System**
- ✅ **Analytics Integration**

## 🚀 Quick Start

### Option 1: One-Click Installation (Recommended)

```bash
# Clone and install in one command
git clone https://github.com/mohamedallam1991/hugo-cal-chargily-booking.git
cd hugo-cal-chargily-booking
./install.sh my-booking-site

# Your site will be running at http://localhost:1313
```

### Option 2: Add to Existing Hugo Site

In your existing Hugo site's `hugo.toml`:

```toml
[module]
  [[module.imports]]
    path = "github.com/mohamedallam1991/hugo-cal-chargily-booking"
```

### Option 3: Start New Hugo Project

```bash
# Create new Hugo site
hugo new site my-booking-site

# Add module to hugo.toml
cat >> hugo.toml << 'EOF'
[module]
  [[module.imports]]
    path = "github.com/mohamedallam1991/hugo-cal-chargily-booking"
EOF

# Create booking page
mkdir -p content
cat > content/consult.md << 'EOF'
---
title: "Book a Consultation"
---

{{< cal-simple >}}
EOF

# Start development server
hugo server
```

## ⚙️ Configuration

### 1. Basic Configuration (`data/cal_config.yaml`)

```yaml
# Cal.com Booking Configuration
booking_methods:
  embed:
    name: "Embedded Calendar"
    description: "Full calendar embedded in page"
    shortcode: "cal-embed"
  floating:
    name: "Floating Button"
    description: "Floating button in corner"
    shortcode: "cal-floating"
  button:
    name: "Custom Button"
    description: "Styled button with hover effects"
    shortcode: "cal-button"

# Default Cal.com settings
default_settings:
  cal_link: "your-username/event-type"
  namespace: "your-event"
  layout: "month_view"
  use_slots_view_on_small_screen: "true"
  hide_event_type_details: false
  primary_color: "#667eea"
  height: "800px"

# Chargily Payment Integration
chargily:
  enabled: true
  api_key: "your-chargily-api-key"
  webhook_secret: "your-webhook-secret"
  currency: "DZD"
  sandbox_mode: true
  payment_methods:
    - "card"
    - "edahabia"
    - "cib"
  success_url: "/booking/success"
  failure_url: "/booking/failure"
  webhook_url: "/api/webhook"
  default_amount: 1500 # 15.00 DZD
```

### 2. UI Configuration

```yaml
# UI Configuration (in data/cal_config.yaml)
ui:
  payment_modal:
    title: "Complete Your Booking"
    subtitle: "Secure payment powered by Chargily"
    button_text: "Pay with Chargily"
    loading_text: "Processing Payment"
    security_text: "Secure Payment"
    instant_text: "Instant Confirmation"

  payment_info:
    title: "Payment Required"
    description: "This booking requires payment confirmation..."

  success_page:
    title: "Payment Successful"
    message: "Thank you for your payment..."

  failure_page:
    title: "Payment Failed"
    message: "We're sorry, but we couldn't process..."
```

### 3. Email Configuration

```yaml
# Email Configuration (in data/cal_config.yaml)
email:
  enabled: false # Set to true when email service is configured
  provider: "resend" # Options: resend, sendgrid, emailjs
  from_email: "noreply@your-domain.com"
  support_email: "support@your-domain.com"
  admin_email: "admin@your-domain.com"
```

## 💳 Chargily Payment Integration

### Supported Payment Methods

- **Credit/Debit Cards** - Visa, Mastercard
- **Edahabia** - Algerian electronic wallet
- **CIB** - Algerian interbank system

### Payment Flow

1. User selects booking time slot
2. Payment modal appears with booking summary
3. User completes payment via Chargily secure gateway
4. Webhook confirms payment and activates booking
5. User redirected to success page with confirmation

### Security Features

- **HMAC Signature Verification** - All webhooks are verified
- **HTTPS Only** - Production requires HTTPS
- **Timeout Protection** - Payment sessions expire after 15 minutes
- **Error Handling** - Comprehensive error management

## 🌩️ Deployment

### Cloudflare Pages (Recommended)

```bash
# Install Wrangler CLI
npm install -g wrangler

# Login to Cloudflare
wrangler login

# Deploy to Cloudflare Pages
wrangler pages deploy public --project-name your-booking-site

# Set environment variables
wrangler pages secret put CHARGILY_API_KEY
wrangler pages secret put CHARGILY_SECRET_KEY
wrangler pages secret put CHARGILY_WEBHOOK_SECRET
```

### Environment Variables

#### Production:

```
CHARGILY_API_KEY=pk_live_your_live_public_key
CHARGILY_SECRET_KEY=sk_live_your_live_secret_key
CHARGILY_WEBHOOK_SECRET=whsec_your_production_webhook_secret
```

#### Development:

```
CHARGILY_API_KEY=test_pk_your_test_public_key
CHARGILY_SECRET_KEY=test_sk_your_test_secret_key
CHARGILY_WEBHOOK_SECRET=whsec_test_your_test_webhook_secret
```

## 🔧 Development

### Local Development

```bash
# Clone module
git clone https://github.com/mohamedallam1991/hugo-cal-chargily-booking.git

# Navigate to module
cd hugo-cal-chargily-booking

# Start development server
hugo server --port 1314

# Or test example site
cd exampleSite
hugo server --port 1313
```

### Testing

```bash
# Test payment flow with test cards
# Visa: 4242424242424242
# Mastercard: 5555555555554444
# Any future expiry date
# Any 3-digit CVV

# Test webhook endpoint
curl -X POST https://your-domain.com/api/webhook \
  -H "Content-Type: application/json" \
  -H "signature: test_signature" \
  -d '{"type":"checkout.paid","data":{"id":"test_payment_123"}}'
```

## 📁 Module Structure

```
hugo-cal-chargily-booking/
├── data/
│   └── cal_config.yaml        # Configuration file
├── layouts/
│   ├── partials/
│   │   ├── cal-embed.html       # Individual method partials
│   │   ├── cal-floating.html
│   │   ├── cal-button.html
│   │   ├── cal-embed-chargily-fixed.html  # Enhanced with payments
│   │   └── chargily-payment-modal.html    # Payment modal
│   └── shortcodes/
│       └── cal-simple.html      # Main booking shortcode
├── content/booking/
│   ├── success.md              # Payment success page
│   └── failure.md              # Payment failure page
├── functions/api/
│   ├── webhook.js              # Chargily webhook handler
│   └── chargily/
│       └── create-payment.js   # Payment creation API
├── exampleSite/
│   ├── hugo.toml              # Example Hugo config
│   └── content/
│       ├── _index.md          # Example homepage
│       └── consult.md          # Example booking page
├── wrangler.toml              # Cloudflare deployment config
├── CHARGILY_SETUP.md          # Complete setup guide
└── README.md                  # This documentation
```

## 🎨 Customization

### Colors and Styling

```yaml
default_settings:
  primary_color: "#667eea"
  hover_color: "#5a67d8"
  text_color: "white"
```

### Multiple Cal.com Links

```yaml
booking_methods:
  consultation:
    name: "Book Consultation"
    cal_link: "user/consultation"
  demo:
    name: "Schedule Demo"
    cal_link: "user/demo"
```

### Conditional Display

```markdown
{{ if eq .Params.booking_method "floating" }}
{{< cal-floating >}}
{{ else if eq .Params.booking_method "button" }}
{{< cal-button >}}
{{ else }}
{{< cal-embed >}}
{{ end }}
```

## 🔍 Troubleshooting

### Quick Health Check

Visit `/health/` on your site to see diagnostic information.

### Common Issues

#### Payment Modal Not Showing

```javascript
// Check browser console for errors
console.log(
  "Chargily modal function available:",
  typeof showChargilyPaymentModal,
);
```

#### Webhook Not Receiving Events

```bash
# Check webhook accessibility
curl -I https://your-domain.com/api/webhook

# Check Cloudflare Functions logs
wrangler pages deployment tail
```

#### Signature Verification Failed

```javascript
// Debug signature verification
console.log("Received signature:", signature);
console.log("Expected signature:", computedSignature);
```

### Complete Troubleshooting Guide

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for detailed solutions to all common issues.

## 📚 Advanced Usage

### Adding Custom Booking Methods

1. Create new partial in `layouts/partials/your-method.html`
2. Add method to `data/cal_config.yaml`:

```yaml
booking_methods:
  your_method:
    name: "Your Method"
    description: "Your description"
    shortcode: "your-method"
```

3. Update `layouts/shortcodes/cal-simple.html` to include your method

### Analytics Integration

```yaml
# Analytics Configuration
analytics:
  enabled: true
  google_analytics_id: "GA-XXXXXXXXX"
  facebook_pixel_id: "XXXXXXXXXXXXXXXX"
```

### Email Service Integration

```yaml
# Email Configuration
email:
  enabled: true
  provider: "resend"
  from_email: "noreply@your-domain.com"
  # Add your Resend API key to environment variables
```

## 📞 Support

### Chargily Support

- **Email**: support@chargily.com
- **Documentation**: https://docs.chargily.com
- **API Reference**: https://api.chargily.com/docs

### Module Support

- **Issues**: [GitHub Issues](https://github.com/mohamedallam1991/hugo-cal-chargily-booking/issues)
- **Documentation**: [Wiki](https://github.com/mohamedallam1991/hugo-cal-chargily-booking/wiki)
- **Discussions**: [GitHub Discussions](https://github.com/mohamedallam1991/hugo-cal-chargily-booking/discussions)

## 🔄 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Commit changes: `git commit -m 'Add amazing feature'`
5. Push to branch: `git push origin feature/amazing-feature`
6. Submit pull request

## 📄 License

MIT License - see LICENSE file for details.

## 🎉 Changelog

### v2.0.0 (Latest - Production Ready)

- 🚀 **Complete Chargily Integration**: Full payment processing for Algerian market
- 🔒 **Enhanced Security**: Webhook verification, signature validation, HTTPS enforcement
- 📱 **Mobile-Optimized**: Responsive payment modal and pages
- 🛠️ **Production Deployment**: Cloudflare Pages configuration, environment variables
- 📧 **Email System**: Automated payment confirmations and notifications
- 📊 **Analytics Ready**: Google Analytics, Facebook Pixel integration
- 🎨 **Enhanced UI**: Improved payment flow, success/failure pages
- 🔧 **Configuration System**: Centralized config with UI, email, and security settings
- 📚 **Complete Documentation**: Setup guides, troubleshooting, best practices

### v1.2.0

- 🚀 **One-Click Installation**: Added `install.sh` script for complete setup
- 🎨 **Complete Template System**: Added fallback templates that work out-of-the-box
- 🔧 **Health Check Page**: Added `/health/` endpoint for debugging
- 📚 **Comprehensive Troubleshooting**: Added detailed TROUBLESHOOTING.md guide

### v1.1.0

- Enhanced documentation with comprehensive setup guides
- Added automated setup script (setup.sh)
- Improved troubleshooting section
- Added module structure documentation
- Better configuration examples
- Theme integration guidelines

### v1.0.0

- Initial release
- Three booking methods (embedded, floating, custom button)
- Configuration-driven system
- Comprehensive documentation
- Example site included

---

**🚀 Ready for Production!** This module is now production-ready with complete Chargily payment integration, security features, and deployment configuration.

**Happy booking! 💳✨**
