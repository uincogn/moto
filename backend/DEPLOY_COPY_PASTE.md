# 🚀 DEPLOY KM$ - COPIAR E COLAR NO SHELL

## 📋 SOLUÇÃO: COMANDOS DIRETOS NO SEU SHELL

Como o projeto está no Replit (não no seu computador), copie e cole estes comandos **um por vez** no seu shell:

### 1. CONFIGURAR TOKEN
```bash
export FLY_ACCESS_TOKEN="FlyV1 fm2_lJPECAAAAAAACYErxBDkVgosdn30xIbS9FAOVp+ywrVodHRwczovL2FwaS5mbHkuaW8vdjGUAJLOABI7SB8Lk7lodHRwczovL2FwaS5mbHkuaW8vYWFhL3YxxDwI7wQ7fbIMBIIRP0AYKfEsO7MhqwxwrBzjXZ/VgTgWCYd+/XxqNHSVCw4Sfw77d3OKpHJHf6cOswl9mqHETjyVS3gnd8h9K1YCTccHu1o8eR84fJOmHOxZj4kB3Y7GJ48qCpdPha3PKXies5yoLmcyg8J612NY6BqJtjyYSgPr3Lwf8T018beMJCaLAsQgLTT6IkzuU8bmmIkueYElF3GFSzhxAUjYFkefmtR27ng="
```

### 2. TESTAR CONEXÃO
```bash
flyctl version
```

### 3. CONFIGURAR SECRETS (um por vez)
```bash
flyctl secrets set --app moto SUPABASE_URL="https://zmxigdwkgxirixtmwtwr.supabase.co"
```

```bash
flyctl secrets set --app moto SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpteGlnZHdrZ3hpcml4dG13dHdyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMxMjE3MzEsImV4cCI6MjA2ODY5NzczMX0.saLVW4cLUc4cr6125un6rryD51y1e65lDbL8L27oorA"
```

```bash
flyctl secrets set --app moto SUPABASE_SERVICE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpteGlnZHdrZ3hpcml4dG13dHdyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MzEyMTczMSwiZXhwIjoyMDY4Njk3NzMxfQ.DEiiKSecLleYx3dZZx0ExqnIzNI_jg_HKjzu9f_E38w"
```

```bash
flyctl secrets set --app moto JWT_SECRET="km_dollar_super_secret_jwt_2025_fly_production_key_v1_secure_hash_256"
```

```bash
flyctl secrets set --app moto JWT_EXPIRES_IN="7d"
```

```bash
flyctl secrets set --app moto JWT_ISSUER="km_dollar_api"
```

```bash
flyctl secrets set --app moto DATABASE_URL="postgresql://postgres.zmxigdwkgxirixtmwtwr:[\$&&KM\$@123@]@aws-0-sa-east-1.pooler.supabase.com:5432/postgres"
```

### 4. FAZER DEPLOY
```bash
flyctl deploy --app moto
```

### 5. AGUARDAR E TESTAR
```bash
sleep 30
curl https://moto.fly.dev/health
```

### 6. VERIFICAR STATUS
```bash
flyctl status --app moto
```

## ⚠️ IMPORTANTE:
- Execute os comandos **um por vez**
- Aguarde cada comando terminar antes do próximo
- Se der erro em algum secret, continue com os próximos
- O deploy pode levar 3-5 minutos

## ✅ RESULTADO ESPERADO:
Depois de executar todos os comandos, você deve ver:
- Deploy concluído com sucesso
- https://moto.fly.dev/health respondendo
- Backend KM$ funcionando em produção

## 📞 QUANDO TERMINAR:
Me avise o resultado aqui no Replit para eu atualizar o frontend e testar a integração completa!