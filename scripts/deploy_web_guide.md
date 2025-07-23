# 🚀 DEPLOY FINAL VIA WEB INTERFACE

## 📋 PASSO-A-PASSO DEPLOY FLY.IO

### 1️⃣ Acesse o Dashboard
- URL: https://fly.io/apps/moto
- Faça login na sua conta

### 2️⃣ Deploy Manual
- Clique no botão **"Deploy"** no topo da página
- Ou acesse: https://fly.io/apps/moto/deploy

### 3️⃣ Confirmar Deploy
- O sistema detectará as mudanças no código
- Clique em **"Deploy"** para confirmar
- Aguarde o build (2-3 minutos)

## 🔧 MUDANÇAS APLICADAS (Ready para Deploy)

### ✅ Correções Implementadas:
1. **HTTPS Middleware** - Permite health check HTTP interno
2. **Fly.io Headers** - Detecta requisições internas do Fly
3. **Health Check Config** - Grace period aumentado para 30s
4. **Auto-stop disabled** - Máquina sempre ativa (min_machines_running = 1)

### ✅ Arquivos Atualizados:
- `backend/lib/middleware/https_enforcer.dart`
- `backend/fly.toml`

## 🧪 TESTES APÓS DEPLOY

Execute estes comandos para testar:

```bash
# Health check
curl https://moto.fly.dev/health

# Registro de usuário
curl -X POST https://moto.fly.dev/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Teste","email":"teste@fly.dev","password":"123456"}'

# Login
curl -X POST https://moto.fly.dev/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"teste@fly.dev","password":"123456"}'
```

## 🎯 RESULTADO ESPERADO

✅ Health check deve retornar: `{"status": "OK", "message": "KM$ Backend Dart funcionando"}`
✅ Registro deve retornar: Token JWT válido
✅ Login deve retornar: Token JWT válido

## 📱 PRÓXIMO PASSO

Após deploy bem-sucedido:
1. Teste os endpoints acima
2. Atualize URL do frontend para `https://moto.fly.dev`
3. Compile o APK via Codemagic
4. Teste integração completa