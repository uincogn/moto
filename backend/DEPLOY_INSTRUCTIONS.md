# 🚀 DEPLOY KM$ BACKEND - SHELL LOCAL

## 📋 PRÉ-REQUISITOS
- flyctl instalado localmente (✅ já feito conforme screenshots)
- Token UNI criado no Fly.io (✅ já criado)
- Acesso ao shell local

## 🎯 COMANDOS PARA EXECUTAR NO SEU SHELL

### 1. Navegar para a pasta do projeto
```bash
cd /caminho/para/km$/backend
```

### 2. Dar permissão ao script
```bash
chmod +x deploy_local_shell.sh
```

### 3. Executar o deploy
```bash
./deploy_local_shell.sh
```

## 📁 OU EXECUTAR COMANDOS MANUALMENTE

Se preferir executar passo a passo:

### 1. Configurar token
```bash
export FLY_ACCESS_TOKEN="FlyV1 fm2_lJPECAAAAAAACYErxBDkVgosdn30xIbS9FAOVp+ywrVodHRwczovL2FwaS5mbHkuaW8vdjGUAJLOABI7SB8Lk7lodHRwczovL2FwaS5mbHkuaW8vYWFhL3YxxDwI7wQ7fbIMBIIRP0AYKfEsO7MhqwxwrBzjXZ/VgTgWCYd+/XxqNHSVCw4Sfw77d3OKpHJHf6cOswl9mqHETjyVS3gnd8h9K1YCTccHu1o8eR84fJOmHOxZj4kB3Y7GJ48qCpdPha3PKXies5yoLmcyg8J612NY6BqJtjyYSgPr3Lwf8T018beMJCaLAsQgLTT6IkzuU8bmmIkueYElF3GFSzhxAUjYFkefmtR27ng="
```

### 2. Configurar PATH (se necessário)
```bash
export FLYCTL_INSTALL="/home/runner/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"
```

### 3. Configurar secrets
```bash
flyctl secrets set --app moto SUPABASE_URL="https://zmxigdwkgxirixtmwtwr.supabase.co"
flyctl secrets set --app moto SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpteGlnZHdrZ3hpcml4dG13dHdyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMxMjE3MzEsImV4cCI6MjA2ODY5NzczMX0.saLVW4cLUc4cr6125un6rryD51y1e65lDbL8L27oorA"
flyctl secrets set --app moto JWT_SECRET="km_dollar_super_secret_jwt_2025_fly_production_key_v1_secure_hash_256"
```

### 4. Fazer deploy
```bash
flyctl deploy --app moto
```

### 5. Testar
```bash
curl https://moto.fly.dev/health
```

## ✅ RESULTADO ESPERADO

Depois do deploy com sucesso:
- Backend funcionando em: https://moto.fly.dev
- Health check respondendo
- Todos os secrets configurados
- Logs sem erros

## 🔧 RESOLUÇÃO DE PROBLEMAS

### Erro de autenticação
- Verifique se o token está correto
- Confirme se o flyctl está no PATH

### Erro de build
- Verifique se todos os arquivos estão na pasta backend/
- Confirme se o Dockerfile existe

### Erro de secrets
- Execute os comandos de secrets um por vez
- Verifique se não há caracteres especiais quebrados

## 📞 PRÓXIMOS PASSOS

Após deploy bem-sucedido:
1. ✅ Backend online em https://moto.fly.dev
2. 🔄 Atualizar frontend para usar URL de produção
3. 📱 Compilar APK no Codemagic
4. 🧪 Testar integração completa