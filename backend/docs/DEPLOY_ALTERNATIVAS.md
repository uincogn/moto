# 🚀 ALTERNATIVAS GRATUITAS PARA DEPLOY

O Replit está pedindo upgrade, então vamos usar plataformas gratuitas:

## 🥇 **OPÇÃO 1: RENDER.COM (RECOMENDADO)**

### Vantagens:
- ✅ Plano gratuito permanente
- ✅ Suporte Docker/Dockerfile
- ✅ SSL automático
- ✅ Deploy via GitHub automático

### Como fazer:
1. **Acesse**: https://render.com
2. **Sign up** com GitHub
3. **New Web Service** → Connect Repository
4. **Configure**:
   - **Name**: km-dollar-backend
   - **Environment**: Docker
   - **Build Command**: `dart pub get`
   - **Start Command**: `dart run bin/server.dart`
   - **Plan**: Free

### Arquivo já criado:
- ✅ `render.yaml` com todas as configurações

## 🥈 **OPÇÃO 2: FLY.IO**

### Como fazer:
```bash
# No seu PC (não no Replit):
curl -L https://fly.io/install.sh | sh
flyctl auth signup
flyctl launch --dockerfile
```

## 🥉 **OPÇÃO 3: GLITCH.COM**

### Como fazer:
1. **Acesse**: https://glitch.com
2. **Import from GitHub**
3. **Configure** como Node.js project

## 🎯 **RECOMENDAÇÃO**

**Use Render.com** - É o mais simples:

1. Vá para https://render.com
2. Login com GitHub
3. Conecte este repositório
4. Configuração automática via `render.yaml`
5. Deploy automático!

**URL final**: `https://km-dollar-backend.onrender.com`

## ⚡ **PRÓXIMOS PASSOS**

Após deploy bem-sucedido:
1. Me passe a URL final
2. Atualizo frontend para usar nova URL
3. Build APK via Codemagic
4. App 100% funcional!