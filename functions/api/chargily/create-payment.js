// Chargily Payment Creation Endpoint
// This creates a payment session and returns the payment URL

export async function onRequestPost(context) {
    const { request, env } = context;

    // Only allow POST requests
    if (request.method !== 'POST') {
        return new Response('Method not allowed', { status: 405 });
    }

    try {
        // Parse request body
        const paymentData = await request.json();
        
        // Validate required fields
        const requiredFields = ['amount', 'currency', 'product', 'description'];
        for (const field of requiredFields) {
            if (!paymentData[field]) {
                return new Response(JSON.stringify({
                    error: `Missing required field: ${field}`,
                    status: 'failed'
                }), {
                    status: 400,
                    headers: { 'Content-Type': 'application/json' }
                });
            }
        }

        // Get Chargily API key
        const apiKey = env.CHARGILY_SECRET_KEY;
        if (!apiKey) {
            console.error('❌ CHARGILY_SECRET_KEY not configured');
            return new Response(JSON.stringify({
                error: 'Payment service not configured',
                status: 'failed'
            }), {
                status: 500,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        // Create payment session with Chargily
        const chargilyPaymentData = {
            amount: paymentData.amount,
            currency: paymentData.currency,
            description: paymentData.description,
            success_url: paymentData.success_url || `${request.url.split('/api/')[0]}/booking/success`,
            failure_url: paymentData.failure_url || `${request.url.split('/api/')[0]}/booking/failure`,
            metadata: paymentData.metadata || {}
        };

        console.log('🔄 Creating Chargily payment session:', JSON.stringify(chargilyPaymentData, null, 2));

        // Make request to Chargily API
        const chargilyResponse = await fetch('https://api.chargily.com/v2/checkouts', {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${apiKey}`,
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify(chargilyPaymentData)
        });

        if (!chargilyResponse.ok) {
            const errorData = await chargilyResponse.text();
            console.error('❌ Chargily API error:', errorData);
            
            return new Response(JSON.stringify({
                error: 'Failed to create payment session',
                details: errorData,
                status: 'failed'
            }), {
                status: 500,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        const chargilyResult = await chargilyResponse.json();
        console.log('✅ Chargily payment session created:', JSON.stringify(chargilyResult, null, 2));

        // Store payment information in KV for tracking
        if (env.PAYMENTS_KV) {
            const paymentInfo = {
                id: chargilyResult.id,
                amount: paymentData.amount,
                currency: paymentData.currency,
                product: paymentData.product,
                description: paymentData.description,
                metadata: paymentData.metadata,
                status: 'pending',
                created_at: new Date().toISOString(),
                payment_url: chargilyResult.payment_url
            };
            
            await env.PAYMENTS_KV.put(`payment_${chargilyResult.id}`, JSON.stringify(paymentInfo));
            console.log(`💾 Payment ${chargilyResult.id} stored in KV`);
        }

        // Return payment URL to frontend
        return new Response(JSON.stringify({
            payment_url: chargilyResult.payment_url,
            payment_id: chargilyResult.id,
            status: 'success'
        }), {
            headers: { 'Content-Type': 'application/json' }
        });

    } catch (error) {
        console.error('❌ Payment creation error:', error);
        return new Response(JSON.stringify({
            error: 'Failed to create payment',
            details: error.message,
            status: 'failed'
        }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}

// Handle CORS preflight requests
export async function onRequestOptions() {
    return new Response(null, {
        status: 200,
        headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'POST, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization'
        }
    });
}
