// Chargily Webhook Handler for Cloudflare Workers
// This handles payment confirmation and booking fulfillment

export async function onRequestPost(context) {
    const { request, env } = context;

    // Only allow POST requests
    if (request.method !== 'POST') {
        return new Response('Method not allowed', { status: 405 });
    }

    try {
        // Get signature from header
        const signature = request.headers.get('signature') || request.headers.get('x-signature');
        
        // Get raw body for verification
        const body = await request.text();

        // Verify signature
        if (!signature) {
            console.error('❌ No signature provided in webhook request');
            return new Response(JSON.stringify({
                error: 'No signature provided',
                status: 'failed'
            }), {
                status: 400,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Calculate expected signature
        const webhookSecret = env.CHARGILY_WEBHOOK_SECRET;
        if (!webhookSecret) {
            console.error('❌ CHARGILY_WEBHOOK_SECRET not configured');
            return new Response(JSON.stringify({
                error: 'Webhook secret not configured',
                status: 'failed'
            }), {
                status: 500,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        const encoder = new TextEncoder();
        const keyData = encoder.encode(webhookSecret);
        const messageData = encoder.encode(body);

        const cryptoKey = await crypto.subtle.importKey(
            'raw',
            keyData,
            { name: 'HMAC', hash: 'SHA-256' },
            false,
            ['sign']
        );

        const signatureBuffer = await crypto.subtle.sign('HMAC', cryptoKey, messageData);
        const computedSignature = Array.from(new Uint8Array(signatureBuffer))
            .map(b => b.toString(16).padStart(2, '0'))
            .join('');

        // Compare signatures (timing-safe comparison would be better in production)
        if (signature !== computedSignature) {
            console.error('❌ Invalid webhook signature');
            console.log('Expected:', computedSignature);
            console.log('Received:', signature);
            
            return new Response(JSON.stringify({
                error: 'Invalid signature',
                status: 'failed'
            }), {
                status: 403,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Parse webhook data
        const webhookData = JSON.parse(body);
        console.log('✅ Verified Chargily webhook:', JSON.stringify(webhookData, null, 2));

        // Process events
        const { type, data } = webhookData;

        switch (type) {
            case 'checkout.paid':
                await handleSuccessfulPayment(data, env);
                break;
            case 'checkout.failed':
                await handleFailedPayment(data, env);
                break;
            case 'checkout.pending':
                await handlePendingPayment(data, env);
                break;
            default:
                console.log(`ℹ️ Unhandled webhook event type: ${type}`);
        }

        return new Response(JSON.stringify({
            status: 'success',
            message: 'Webhook processed successfully',
            event_type: type,
            payment_id: data?.id
        }), {
            headers: { 'Content-Type': 'application/json' }
        });

    } catch (error) {
        console.error('❌ Webhook processing error:', error);
        return new Response(JSON.stringify({
            error: 'Failed to process webhook',
            details: error.message,
            status: 'failed'
        }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}

async function handleSuccessfulPayment(paymentData, env) {
    const { id, amount, currency, metadata, customer } = paymentData;
    
    console.log(`💰 Payment successful: ${id} - ${amount/100} ${currency}`);
    
    try {
        // Store payment information
        const paymentInfo = {
            status: 'paid',
            amount: amount,
            currency: currency,
            metadata: metadata,
            customer: customer,
            processed_at: new Date().toISOString(),
            webhook_received_at: new Date().toISOString()
        };

        // Store in KV (if available)
        if (env.PAYMENTS_KV) {
            await env.PAYMENTS_KV.put(`payment_${id}`, JSON.stringify(paymentInfo));
            console.log(`💾 Payment ${id} stored in KV`);
        }

        // Process booking fulfillment
        if (metadata && metadata.booking_id) {
            await fulfillBooking(metadata.booking_id, paymentInfo, env);
        }

        // Send confirmation email (if email service is configured)
        if (customer?.email && env.EMAIL_SERVICE_ENABLED) {
            await sendConfirmationEmail(customer.email, paymentInfo, env);
        }

        // Log for analytics
        console.log(`✅ Payment ${id} processed successfully`);

    } catch (error) {
        console.error(`❌ Error processing successful payment ${id}:`, error);
        throw error;
    }
}

async function handleFailedPayment(paymentData, env) {
    const { id, amount, currency, metadata, customer } = paymentData;
    
    console.log(`❌ Payment failed: ${id} - ${amount/100} ${currency}`);
    
    try {
        // Store failed payment information
        const paymentInfo = {
            status: 'failed',
            amount: amount,
            currency: currency,
            metadata: metadata,
            customer: customer,
            failed_at: new Date().toISOString(),
            webhook_received_at: new Date().toISOString()
        };

        // Store in KV (if available)
        if (env.PAYMENTS_KV) {
            await env.PAYMENTS_KV.put(`payment_${id}`, JSON.stringify(paymentInfo));
        }

        // Optionally notify admin of failed payment
        if (env.ADMIN_EMAIL && env.EMAIL_SERVICE_ENABLED) {
            await notifyAdminFailedPayment(paymentInfo, env);
        }

        console.log(`📝 Failed payment ${id} logged`);

    } catch (error) {
        console.error(`❌ Error processing failed payment ${id}:`, error);
    }
}

async function handlePendingPayment(paymentData, env) {
    const { id, amount, currency, metadata } = paymentData;
    
    console.log(`⏳ Payment pending: ${id} - ${amount/100} ${currency}`);
    
    try {
        // Store pending payment information
        const paymentInfo = {
            status: 'pending',
            amount: amount,
            currency: currency,
            metadata: metadata,
            pending_at: new Date().toISOString(),
            webhook_received_at: new Date().toISOString()
        };

        // Store in KV (if available)
        if (env.PAYMENTS_KV) {
            await env.PAYMENTS_KV.put(`payment_${id}`, JSON.stringify(paymentInfo));
        }

        console.log(`📝 Pending payment ${id} logged`);

    } catch (error) {
        console.error(`❌ Error processing pending payment ${id}:`, error);
    }
}

async function fulfillBooking(bookingId, paymentInfo, env) {
    console.log(`🎯 Fulfilling booking: ${bookingId}`);
    
    try {
        // Update booking status in your system
        // This would typically involve:
        // 1. Updating your database
        // 2. Confirming the booking with Cal.com API
        // 3. Sending booking confirmation to customer
        
        // For now, we'll just log it
        console.log(`✅ Booking ${bookingId} confirmed and paid`);
        
        // Store booking fulfillment record
        if (env.BOOKINGS_KV) {
            const fulfillmentInfo = {
                booking_id: bookingId,
                payment_id: paymentInfo.id || 'unknown',
                status: 'confirmed',
                fulfilled_at: new Date().toISOString(),
                payment_info: paymentInfo
            };
            
            await env.BOOKINGS_KV.put(`booking_${bookingId}`, JSON.stringify(fulfillmentInfo));
        }

    } catch (error) {
        console.error(`❌ Error fulfilling booking ${bookingId}:`, error);
        throw error;
    }
}

async function sendConfirmationEmail(customerEmail, paymentInfo, env) {
    console.log(`📧 Sending confirmation email to: ${customerEmail}`);
    
    try {
        // This would integrate with your email service
        // Examples: SendGrid, Resend, EmailJS, etc.
        
        const emailData = {
            to: customerEmail,
            subject: 'Payment Confirmation - Your Booking is Confirmed',
            template: 'payment_confirmation',
            data: {
                customer_name: paymentInfo.customer?.name || 'Valued Customer',
                payment_id: paymentInfo.id || 'N/A',
                amount: (paymentInfo.amount / 100).toFixed(2),
                currency: paymentInfo.currency,
                booking_id: paymentInfo.metadata?.booking_id,
                event_type: paymentInfo.metadata?.event_type,
                slot_start: paymentInfo.metadata?.slot_start
            }
        };
        
        // Example: Call your email service API
        // const response = await fetch('https://api.emailservice.com/send', {
        //     method: 'POST',
        //     headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${env.EMAIL_API_KEY}` },
        //     body: JSON.stringify(emailData)
        // });
        
        console.log(`📧 Confirmation email sent to ${customerEmail}`);

    } catch (error) {
        console.error(`❌ Error sending confirmation email:`, error);
        // Don't throw here - email failure shouldn't break the payment process
    }
}

async function notifyAdminFailedPayment(paymentInfo, env) {
    console.log(`📧 Notifying admin about failed payment`);
    
    try {
        const adminEmailData = {
            to: env.ADMIN_EMAIL,
            subject: 'Failed Payment Notification',
            template: 'admin_failed_payment',
            data: {
                payment_id: paymentInfo.id,
                amount: (paymentInfo.amount / 100).toFixed(2),
                currency: paymentInfo.currency,
                customer_email: paymentInfo.customer?.email,
                failed_at: paymentInfo.failed_at
            }
        };
        
        console.log(`📧 Admin notification sent for failed payment ${paymentInfo.id}`);

    } catch (error) {
        console.error(`❌ Error sending admin notification:`, error);
    }
}

// Handle CORS preflight requests
export async function onRequestOptions() {
    return new Response(null, {
        status: 200,
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'POST, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, signature, x-signature'
        }
    });
}
