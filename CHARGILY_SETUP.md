# 🚀 Chargily Integration Setup Guide

This guide walks you through setting up the complete Chargily payment integration for your Hugo Cal.com booking system.

## 📋 Prerequisites

1. **Chargily Account**: [Sign up at Chargily](https://chargily.com)
2. **Cloudflare Account**: [Sign up at Cloudflare](https://cloudflare.com)
3. **Domain Name**: For production deployment
4. **Node.js**: v16+ (for local development)

## ⚙️ Step 1: Configure Chargily

### 1.1 Get API Keys

1. Login to [Chargily Dashboard](https://app.chargily.com)
2. Go to **Settings → API Keys**
3. Create **Test Keys** for development:
   - **Public Key**: `test_pk_...`
   - **Secret Key**: `test_sk_...`
   - **Webhook Secret**: `whsec_test_...`

### 1.2 Configure Webhook

1. In Chargily Dashboard, go to **Settings → Webhooks**
2. Add webhook URL: `https://your-domain.com/api/webhook`
3. Set secret: `whsec_test_your_webhook_secret`
4. Select events:
   - `checkout.paid`
   - `checkout.failed`
   - `checkout.pending`

## 🌩️ Step 2: Configure Cloudflare

### 2.1 Set up Cloudflare Pages

```bash
# Install Wrangler CLI
npm install -g wrangler

# Login to Cloudflare
wrangler login

# Deploy to Cloudflare Pages
wrangler pages deploy public --project-name your-booking-site
```

### 2.2 Configure Environment Variables

In Cloudflare Dashboard → Settings → Environment Variables:

#### Production Variables:
```
CHARGILY_API_KEY=pk_live_your_live_public_key
CHARGILY_SECRET_KEY=sk_live_your_live_secret_key
CHARGILY_WEBHOOK_SECRET=whsec_your_production_webhook_secret
```

#### Development Variables:
```
CHARGILY_API_KEY=test_pk_your_test_public_key
CHARGILY_SECRET_KEY=test_sk_your_test_secret_key
CHARGILY_WEBHOOK_SECRET=whsec_test_your_test_webhook_secret
```

### 2.3 Set up KV Namespaces

```bash
# Create KV namespaces
wrangler kv:namespace create "PAYMENTS_KV"
wrangler kv:namespace create "BOOKINGS_KV"

# Update wrangler.toml with the returned IDs
```

## 🔧 Step 3: Configure Hugo Site

### 3.1 Update Configuration

Edit `data/cal_config.yaml`:

```yaml
# Chargily Payment Integration
chargily:
  enabled: true
  api_key: "test_pk_YOUR_PUBLIC_KEY_HERE"
  webhook_secret: "whsec_test_YOUR_WEBHOOK_SECRET_HERE"
  currency: "DZD"
  sandbox_mode: true
  payment_methods:
    - "card"
    - "edahabia"
    - "cib"
  success_url: "/booking/success"
  failure_url: "/booking/failure"
  webhook_url: "/api/webhook"
```

### 3.2 Update Hugo Configuration

Edit `hugo.toml`:

```toml
[params]
  # Chargily Configuration
  chargily_api_key = "test_pk_YOUR_PUBLIC_KEY_HERE"
  payment_currency = "DZD"
  enable_payments = true
```

## 🧪 Step 4: Test Integration

### 4.1 Local Testing

```bash
# Start Hugo development server
hugo server -D

# Test the booking flow:
# 1. Visit http://localhost:1313
# 2. Click "Book Now"
# 3. Select time slot
# 4. Payment modal should appear
# 5. Test with test card: 4242424242424242
```

### 4.2 Test Webhook

```bash
# Test webhook endpoint
curl -X POST https://your-domain.com/api/webhook \
  -H "Content-Type: application/json" \
  -H "signature: test_signature" \
  -d '{
    "type": "checkout.paid",
    "data": {
      "id": "test_payment_123",
      "amount": 1500,
      "currency": "DZD"
    }
  }'
```

## 🚀 Step 5: Deploy to Production

### 5.1 Production Deployment

```bash
# Build for production
hugo --minify

# Deploy to Cloudflare Pages
wrangler pages deploy public --project-name your-booking-site

# Set production environment variables
wrangler pages secret put CHARGILY_API_KEY
wrangler pages secret put CHARGILY_SECRET_KEY
wrangler pages secret put CHARGILY_WEBHOOK_SECRET
```

### 5.2 Configure Custom Domain

```bash
# Add custom domain
wrangler pages domain add your-domain.com

# Update DNS records
# Add CNAME: www.your-domain.com → your-site.pages.dev
```

## 🔍 Step 6: Monitor and Debug

### 6.1 Check Logs

```bash
# View real-time logs
wrangler pages deployment tail

# View specific function logs
wrangler pages deployment tail --filter="webhook"
```

### 6.2 Test Payment Flow

1. **Test Card Numbers**:
   - Visa: `4242424242424242`
   - Mastercard: `5555555555554444`
   - Any future expiry date
   - Any 3-digit CVV

2. **Test Scenarios**:
   - ✅ Successful payment
   - ❌ Failed payment (insufficient funds)
   - ❌ Cancelled payment
   - ❌ Network timeout

## 📊 Step 7: Analytics and Monitoring

### 7.1 Payment Analytics

```javascript
// Add to your success page
gtag('event', 'purchase', {
  transaction_id: paymentId,
  currency: 'DZD',
  value: amount / 100
});
```

### 7.2 Error Monitoring

Set up error tracking in your webhook handler:

```javascript
// Add to webhook.js
try {
  // Your webhook logic
} catch (error) {
  console.error('Webhook error:', error);
  // Send to error monitoring service
}
```

## 🔧 Troubleshooting

### Common Issues

#### 1. Payment Modal Not Showing
```javascript
// Check browser console for errors
console.log('Chargily modal function available:', typeof showChargilyPaymentModal);
```

#### 2. Webhook Not Receiving Events
```bash
# Test webhook accessibility
curl -I https://your-domain.com/api/webhook

# Check Cloudflare Functions logs
wrangler pages deployment tail
```

#### 3. Signature Verification Failed
```javascript
// Debug signature verification
console.log('Received signature:', signature);
console.log('Expected signature:', computedSignature);
```

#### 4. CORS Issues
Add CORS headers to your webhook response:
```javascript
return new Response('OK', {
  headers: {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'POST, OPTIONS'
  }
});
```

## 📞 Support

### Chargily Support
- **Email**: support@chargily.com
- **Documentation**: https://docs.chargily.com
- **API Reference**: https://api.chargily.com/docs

### Common Issues and Solutions

1. **Payment creation fails**: Check API key and network connectivity
2. **Webhook verification fails**: Verify webhook secret matches
3. **Booking not confirmed**: Check webhook processing logs
4. **Email not sent**: Configure email service integration

## 🔄 Maintenance

### Regular Tasks

1. **Monitor payment success rates**
2. **Check webhook health**
3. **Update API keys periodically**
4. **Review error logs**
5. **Test payment flow regularly**

### Security Best Practices

1. **Never expose secret keys in frontend**
2. **Always verify webhook signatures**
3. **Use HTTPS everywhere**
4. **Monitor for suspicious activity**
5. **Keep dependencies updated**

## 🎉 Success!

Your Hugo Cal.com booking system now has complete Chargily payment integration! 

### What's Working:
- ✅ Secure payment processing
- ✅ Webhook automation
- ✅ Booking confirmation
- ✅ Success/failure handling
- ✅ Mobile-friendly interface
- ✅ Production-ready deployment

### Next Steps:
1. Set up email notifications
2. Configure analytics
3. Customize branding
4. Add additional payment methods
5. Set up monitoring alerts

---

**Happy booking! 🚀**
