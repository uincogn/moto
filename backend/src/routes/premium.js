const express = require('express');
const router = express.Router();

// Placeholder para rotas Premium
// TODO: Implementar após decisões de gateway de pagamento

/**
 * @route GET /api/premium/status
 * @desc Verificar status Premium do usuário
 * @access Private
 */
router.get('/status', (req, res) => {
  // TODO: Implementar verificação real do banco
  res.json({ 
    success: true, 
    message: 'Status Premium - a ser implementado',
    data: { 
      isPremium: false,
      plan: null,
      expiresAt: null 
    }
  });
});

/**
 * @route POST /api/premium/upgrade
 * @desc Iniciar processo de upgrade para Premium
 * @access Private
 */
router.post('/upgrade', (req, res) => {
  // TODO: Integrar com PagSeguro/Stripe
  const { plan } = req.body; // 'monthly' | 'annual'
  
  res.json({ 
    success: true, 
    message: 'Upgrade Premium - gateway a ser implementado',
    data: { 
      checkoutUrl: 'https://placeholder-checkout-url.com',
      plan: plan || 'monthly'
    }
  });
});

/**
 * @route POST /api/premium/webhook
 * @desc Webhook para confirmação de pagamento
 * @access Public (mas validado por signature)
 */
router.post('/webhook', (req, res) => {
  // TODO: Implementar validação de webhook PagSeguro/Stripe
  res.json({ 
    success: true, 
    message: 'Webhook recebido - validação a ser implementada' 
  });
});

module.exports = router;