# 🚀 DEPLOY FINAL KM$ BACKEND

## ✅ PATH CONFIGURADO COM SUCESSO!
Como visto no screenshot, o flyctl agora está funcionando permanentemente.

## 📋 COMANDOS PARA DEPLOY COMPLETO

Execute estes comandos **um por vez** no seu shell:

### 1. CONFIGURAR TOKEN
```bash
export FLY_ACCESS_TOKEN="FlyV1 fm2_lJPECAAAAAAACYErxBDkVgosdn30xIbS9FAOVp+ywrVodHRwczovL2FwaS5mbHkuaW8vdjGUAJLOABI7SB8Lk7lodHRwczovL2FwaS5mbHkuaW8vYWFhL3YxxDwI7wQ7fbIMBIIRP0AYKfEsO7MhqwxwrBzjXZ/VgTgWCYd+/XxqNHSVCw4Sfw77d3OKpHJHf6cOswl9mqHETjyVS3gnd8h9K1YCTccHu1o8eR84fJOmHOxZj4kB3Y7GJ48qCpdPha3PKXies5yoLmcyg8J612NY6BqJtjyYSgPr3Lwf8T018beMJCaLAsQgLTT6IkzuU8bmmIkueYElF3GFSzhxAUjYFkefmtR27ng="
```

### 2. VERIFICAR LOGIN
```bash
flyctl auth whoami
```

### 3. VER STATUS ATUAL
```bash
flyctl status --app moto
```

### 4. CONFIGURAR SECRETS ESSENCIAIS
```bash
flyctl secrets set --app moto SUPABASE_URL="https://zmxigdwkgxirixtmwtwr.supabase.co"
```

```bash
flyctl secrets set --app moto SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpteGlnZHdrZ3hpcml4dG13dHdyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMxMjE3MzEsImV4cCI6MjA2ODY5NzczMX0.saLVW4cLUc4cr6125un6rryD51y1e65lDbL8L27oorA"
```

```bash
flyctl secrets set --app moto JWT_SECRET="km_dollar_super_secret_jwt_2025_fly_production_key_v1_secure_hash_256"
```

### 5. FAZER DEPLOY
```bash
flyctl deploy --app moto --verbose
```

### 6. AGUARDAR E TESTAR
```bash
sleep 30
curl https://moto.fly.dev/health
```

### 7. VERIFICAR LOGS SE HOUVER PROBLEMA
```bash
flyctl logs --app moto
```

## 🎯 RESULTADO ESPERADO

Após executar todos os comandos:
- Deploy realizado com sucesso
- https://moto.fly.dev/health respondendo com status 200
- Backend KM$ funcionando em produção
- Pronto para integrar com frontend Flutter

## 📞 PRÓXIMOS PASSOS

Quando o deploy estiver funcionando:
1. ✅ Backend online
2. 🔄 Atualizar frontend para URL de produção
3. 📱 Build APK no Codemagic
4. 🧪 Teste completo da aplicação

Execute os comandos e me avise quando terminar ou se encontrar algum erro!