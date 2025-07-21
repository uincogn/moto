# 🖥️ Motouber Backend - API Node.js

## 📋 Sobre

API REST em Node.js para funcionalidades Premium do Motouber. Gerencia autenticação, controle de assinaturas, backup em nuvem e sincronização multi-device.

## 🎯 Funcionalidades

### 📍 Status Atual: **EM DESENVOLVIMENTO**

### 🔄 A Implementar
- **Autenticação**: Cadastro, login, logout via JWT
- **Premium**: Controle de assinaturas e status
- **Backup**: Upload/download dados do app
- **Pagamentos**: Integração PagSeguro/Stripe
- **Multi-device**: Sincronização entre dispositivos

## 🏗️ Arquitetura Planejada

### Estrutura API
```
backend/
├── src/
│   ├── routes/           # Endpoints da API
│   │   ├── auth.js       # /api/auth (cadastro, login)
│   │   ├── premium.js    # /api/premium (upgrade, status)
│   │   └── backup.js     # /api/backup (upload, download)
│   ├── models/           # Esquemas de dados
│   │   ├── User.js       # Modelo de usuário
│   │   └── Backup.js     # Modelo de backup
│   ├── services/         # Lógica de negócio
│   │   ├── database.js   # Conexão PostgreSQL
│   │   ├── payment.js    # Gateway pagamentos
│   │   └── auth.js       # Serviços de autenticação
│   ├── middleware/       # Middlewares Express
│   │   ├── auth.js       # Validação JWT
│   │   └── validation.js # Validação de dados
│   └── config/           # Configurações
│       └── database.js   # Config PostgreSQL
├── docs/                 # Documentação API
├── tests/                # Testes automatizados
├── package.json          # Dependências Node.js
├── server.js            # Servidor principal
└── .env.example         # Variáveis de ambiente
```

## 🔌 Endpoints Planejados

### Autenticação (/api/auth)
```http
POST /api/auth/register    # Cadastro usuário
POST /api/auth/login       # Login (retorna JWT)
POST /api/auth/logout      # Logout
GET  /api/auth/profile     # Perfil do usuário
```

### Premium (/api/premium)
```http
GET  /api/premium/status   # Status assinatura
POST /api/premium/upgrade  # Upgrade para Premium
POST /api/premium/cancel   # Cancelar assinatura
GET  /api/premium/history  # Histórico pagamentos
```

### Backup (/api/backup)
```http
POST /api/backup/upload    # Upload dados app
GET  /api/backup/download  # Download dados
GET  /api/backup/list      # Listar backups
DELETE /api/backup/:id     # Deletar backup
```

### Health Check
```http
GET  /health              # Status da API
```

## 🛠️ Tecnologias

### Stack Principal (100% Dart)
- **Dart 3.0+** - Linguagem unificada com o frontend
- **Shelf 1.4+** - Framework HTTP server
- **Shelf Router** - Roteamento de APIs
- **PostgreSQL** - Banco de dados principal via package postgres
- **Jose** - JWT para autenticação Dart nativo

### Segurança
- **CORS Headers** - Controle de acesso
- **Rate Limiting** - Proteção DDoS customizada
- **Crypto** - Hash de senhas nativo Dart
- **Logging** - Sistema de logs estruturado

### Desenvolvimento
- **DotEnv** - Variáveis de ambiente
- **Test** - Framework de testes Dart
- **Lints** - Análise estática de código

## 🚀 Configuração e Execução

### Pré-requisitos
- Node.js 18+
- PostgreSQL 14+
- NPM ou Yarn

### Instalação
```bash
cd backend
npm install
cp .env.example .env
# Configurar variáveis no .env
```

### Configuração Banco
```sql
-- Criar banco PostgreSQL
CREATE DATABASE motouber;
CREATE USER motouber_user WITH PASSWORD 'sua_senha';
GRANT ALL PRIVILEGES ON DATABASE motouber TO motouber_user;
```

### Variáveis de Ambiente (.env)
```bash
# Servidor
PORT=3000
NODE_ENV=development

# Banco de dados
DATABASE_URL=postgresql://motouber_user:senha@localhost:5432/motouber

# JWT
JWT_SECRET=seu_jwt_secret_muito_seguro_aqui
JWT_EXPIRES_IN=7d

# Pagamentos
PAGSEGURO_TOKEN=seu_token_pagseguro
STRIPE_SECRET_KEY=sk_test_seu_stripe_secret
```

### Executar
```bash
# Desenvolvimento (com auto-restart)
npm run dev

# Produção
npm start

# Verificar saúde da API
curl http://localhost:3000/health
```

## 💳 Sistema de Pagamentos

### Fluxo Premium
```
1. Usuário clica "Upgrade Premium" no app
2. App faz POST /api/premium/upgrade
3. API retorna checkout_url (PagSeguro/Stripe)
4. Usuário paga no gateway
5. Gateway envia webhook para API
6. API atualiza status: isPremium = true
7. App consulta GET /api/premium/status
8. Funcionalidades Premium desbloqueadas
```

### Gateways Suportados (Planejado)
- **PagSeguro** (Brasil - PIX, cartão, boleto)
- **Stripe** (Internacional - cartão)
- **Assinaturas** recorrentes mensais/anuais

## 📊 Modelo de Dados

### Tabela Users
```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  is_premium BOOLEAN DEFAULT false,
  premium_expires_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### Tabela Backups
```sql
CREATE TABLE backups (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  data JSONB NOT NULL,
  size INTEGER,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### Tabela Payments
```sql
CREATE TABLE payments (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  amount DECIMAL(10,2),
  currency VARCHAR(3) DEFAULT 'BRL',
  gateway VARCHAR(50), -- 'pagseguro', 'stripe'
  gateway_transaction_id VARCHAR(255),
  status VARCHAR(50), -- 'pending', 'paid', 'failed'
  created_at TIMESTAMP DEFAULT NOW()
);
```

## 🌐 Deploy e Hosting

### Opções de Deploy
1. **Replit** (Recomendado para MVP)
   - Deploy gratuito
   - PostgreSQL integrado
   - URL automática
   - Escalabilidade limitada

2. **Railway** (Crescimento)
   - PostgreSQL dedicado
   - Deploy via Git
   - Escalabilidade automática
   - $5/mês inicial

3. **Heroku** (Alternativa)
   - PostgreSQL add-on
   - Deploy via Git
   - Dyno sleeping (free tier)

### Configuração Replit
```bash
# replit.nix
{ pkgs }: {
  deps = [
    pkgs.nodejs-18_x
    pkgs.postgresql
  ];
}
```

### Configuração Produção
- **HTTPS** obrigatório
- **Rate limiting** configurado
- **Logs** estruturados
- **Health checks** ativos
- **Backup automático** do banco

## 🔒 Segurança

### Práticas Implementadas
- **JWT** com expiração configurável
- **Bcrypt** para hash de senhas
- **Helmet** para headers seguros
- **Rate limiting** por IP
- **Validação** de entrada (Joi)
- **CORS** configurado

### A Implementar
- **HTTPS** em produção
- **Refresh tokens**
- **2FA** opcional
- **Logs de auditoria**
- **Backup criptografado**

## 🧪 Testes (Planejado)

### Tipos de Testes
```bash
# Testes unitários
npm run test:unit

# Testes de integração
npm run test:integration

# Testes E2E
npm run test:e2e

# Coverage
npm run test:coverage
```

### Ferramentas
- **Jest** - Framework de testes
- **Supertest** - Testes de API
- **Testcontainers** - PostgreSQL para testes

## 📋 Próximos Passos de Desenvolvimento

### FASE 1: Fundação (2-3 semanas)
```bash
[ ] Configurar PostgreSQL no Replit
[ ] Implementar rotas /auth (register, login)
[ ] Sistema JWT completo
[ ] Middleware de autenticação
[ ] Validação de dados com Joi
[ ] Testes básicos da API
```

### FASE 2: Premium (2 semanas)
```bash
[ ] Rotas /premium (status, upgrade)
[ ] Integração PagSeguro
[ ] Webhook de confirmação
[ ] Sistema de assinaturas
[ ] Controle de expiração
```

### FASE 3: Backup (1-2 semanas)
```bash
[ ] Rotas /backup (upload, download)
[ ] Compressão de dados JSON
[ ] Versionamento de backups
[ ] Limpeza automática (30 dias free)
```

### FASE 4: Deploy (1 semana)
```bash
[ ] Deploy no Replit Autoscale
[ ] Configuração HTTPS
[ ] Monitoramento básico
[ ] Documentação API completa
```

## 🔗 Comunicação com Frontend

### Headers Esperados
```http
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

### Respostas Padrão
```json
// Sucesso
{
  "success": true,
  "data": {...},
  "message": "Operação realizada com sucesso"
}

// Erro
{
  "success": false,
  "error": "Código do erro",
  "message": "Mensagem amigável"
}
```

### Estados de Autenticação
```json
// Status Premium
{
  "isPremium": true,
  "expiresAt": "2025-07-21T00:00:00Z",
  "plan": "monthly"
}
```

## ❓ Questões em Debate

### Técnicas
- **Dart backend** vs **Node.js**? (inclinação para Node.js por ecosystem)
- **PostgreSQL** vs **SQLite**? (PostgreSQL para escalabilidade)
- **JWT** vs **Sessions**? (JWT para stateless)
- **Monolito** vs **Microserviços**? (Monolito para MVP)

### Produto  
- **Preço Premium**: R$ 9,90/mês vs R$ 49,90/ano
- **Backup Free**: 30 dias vs 7 dias
- **Trial**: 7 dias grátis vs sem trial
- **Gateway**: PagSeguro vs Stripe vs ambos

### Infraestrutura
- **Deploy**: Replit vs Railway vs Heroku
- **Banco**: Replit PostgreSQL vs externo
- **CDN**: Para assets estáticos?
- **Monitoring**: LogRocket vs Sentry

## 🔄 Migração para Repositório Separado

Quando separado do monorepo:
- Mover todo conteúdo desta pasta para repo próprio
- CI/CD independente (GitHub Actions)
- Deploy separado do frontend
- Comunicação via API endpoints públicos
- Versionamento independente da API

---

**Plataforma**: Node.js + PostgreSQL  
**Status**: Planejamento/Início desenvolvimento
**Deploy Alvo**: Replit Autoscale
**Comunicação**: REST API com Flutter frontend