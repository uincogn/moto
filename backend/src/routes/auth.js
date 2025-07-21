const express = require('express');
const router = express.Router();

// Placeholder para rotas de autenticação
// TODO: Implementar após decisões técnicas

/**
 * @route POST /api/auth/register
 * @desc Cadastrar novo usuário
 * @access Public
 */
router.post('/register', (req, res) => {
  // TODO: Implementar cadastro
  res.json({ 
    success: true, 
    message: 'Rota de cadastro - a ser implementada',
    data: { userId: 'placeholder' }
  });
});

/**
 * @route POST /api/auth/login  
 * @desc Login usuário
 * @access Public
 */
router.post('/login', (req, res) => {
  // TODO: Implementar login + JWT
  res.json({ 
    success: true, 
    message: 'Rota de login - a ser implementada',
    data: { 
      token: 'jwt_placeholder',
      user: { id: 1, email: 'test@example.com', isPremium: false }
    }
  });
});

/**
 * @route GET /api/auth/profile
 * @desc Obter perfil do usuário autenticado
 * @access Private
 */
router.get('/profile', (req, res) => {
  // TODO: Implementar com middleware de auth
  res.json({ 
    success: true, 
    message: 'Perfil do usuário - requer implementação JWT middleware',
    data: { id: 1, email: 'test@example.com', isPremium: false }
  });
});

module.exports = router;