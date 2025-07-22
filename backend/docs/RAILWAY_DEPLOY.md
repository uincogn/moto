# 🚂 GUIA RAILWAY DEPLOY - KM$ Backend

## 📋 **CHECKLIST PRÉ-DEPLOY**

### 1. **Criar Conta Railway**
- ✅ Acesse: https://railway.app
- ✅ Login com GitHub (recomendado)
- ✅ Conectar este repositório

### 2. **Configurar Deploy**
- ✅ New Project → Deploy from GitHub repo
- ✅ Selecionar este repositório
- ✅ Root Directory: `/backend` (importante!)
- ✅ Build Command: `dart pub get`
- ✅ Start Command: `dart run bin/server.dart`

### 3. **Variáveis de Ambiente Obrigatórias**

Copie e cole estas variáveis no Railway Dashboard:

```env
# SERVIDOR
PORT=3000
HOST=0.0.0.0
ENVIRONMENT=production

# JWT (gere uma chave forte)
JWT_SECRET=km_dollar_super_secret_jwt_2025_railway_production_key_v1_secure
JWT_EXPIRES_IN=7d
JWT_ISSUER=km_dollar_api

# SUPABASE (suas credenciais existentes)
SUPABASE_URL=https://seu-projeto.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIs...
SUPABASE_SERVICE_KEY=eyJhbGciOiJIUzI1NiIs...

# HTTPS/SEGURANÇA
FORCE_HTTPS=true

# RATE LIMITING
RATE_LIMIT_REQUESTS=100
RATE_LIMIT_WINDOW_MINUTES=15

# BACKUP
MAX_BACKUP_SIZE_MB=10
BACKUP_RETENTION_DAYS_FREE=30
BACKUP_RETENTION_DAYS_PREMIUM=-1
```

### 4. **Pagamentos (Opcional - pode adicionar depois)**

```env
# PAGSEGURO (para implementar depois)
PAGSEGURO_TOKEN=SEU_TOKEN_PAGSEGURO_AQUI
PAGSEGURO_SANDBOX=false
PAGSEGURO_NOTIFICATION_URL=https://sua-app.railway.app/api/premium/webhook
```

## 🔧 **PASSOS NO RAILWAY**

1. **Deploy Inicial:**
   - Project Settings → Variables
   - Colar todas as variáveis acima
   - Deploy → Aguardar build (2-3 min)

2. **Obter URL:**
   - Após deploy, copiar URL (ex: `https://app-name.railway.app`)
   - Será essa URL que o frontend vai usar

3. **Testar API:**
   ```bash
   curl https://sua-app.railway.app/health
   # Deve retornar: {"status": "ok", "timestamp": "..."}
   ```

## ✅ **VALIDAÇÃO PÓS-DEPLOY**

- [ ] `/health` retorna 200 OK
- [ ] `/api/auth/register` aceita POST
- [ ] `/api/auth/login` aceita POST  
- [ ] Headers CORS configurados
- [ ] HTTPS funcionando

## 🎯 **PRÓXIMOS PASSOS**

Após deploy bem-sucedido:
1. Atualizar URL no frontend (`ApiService`)
2. Build APK via Codemagic
3. Teste integrado completo

**URL atual do frontend:** `https://km-dollar-backend.replit.app`
**URL Railway:** `https://sua-app.railway.app` (substituir)