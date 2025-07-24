#!/bin/bash

echo "🚀 KM$ DEPLOY VIA SHELL - MÉTODO CORRETO"
echo "========================================"

# Configurar token corretamente
export FLY_ACCESS_TOKEN="FlyV1 fm2_lJPECAAAAAAACYErxBCQGQgyMVHno1JvFCen3wUmwrVodHRwczovL2FwaS5mbHkuaW8vdjGUAJLOABI7SB8Lk7lodHRwczovL2FwaS5mbHkuaW8vYWFhL3YxxDwAWRD/nVGYinnK7D4rMEGm+LnHnZNAWP9taMgquwhTHtzYfr9d8U0mJpKlZMp2AHYf3iS5T+/RgbrL3hXETvUuFloC704WsBN2jFuHVg8fyuKTYdgcTE9EyHFLAyRYl+uS1XTa4V6tA6HPHa8N+X0g3DH//lidZTDYrc3q6EZT1vkzT4ZUO4kXLZ+0usQgYSKUZnJ1yY9zMwhGSGwa8r4TmGaq3Mt3IgJth4EDL5g="

# Criar arquivo de configuração do fly
mkdir -p ~/.fly
cat > ~/.fly/config.yml << EOF
access_token: $FLY_ACCESS_TOKEN
organization: personal
EOF

echo "✅ Token configurado"

# Verificar se flyctl está disponível
FLYCTL_PATH="/home/runner/.fly/bin/flyctl"
if [ ! -f "$FLYCTL_PATH" ]; then
    echo "❌ Flyctl não encontrado, instalando..."
    mkdir -p /home/runner/.fly/bin
    curl -L https://github.com/superfly/flyctl/releases/download/v0.3.160/flyctl_0.3.160_Linux_x86_64.tar.gz | tar -xz -C /home/runner/.fly/bin
    chmod +x /home/runner/.fly/bin/flyctl
fi

echo "✅ Flyctl disponível"

# Teste de conectividade
echo "🔍 Testando conexão..."
$FLYCTL_PATH version

# Configurar secrets PRIMEIRO
echo "🔐 Configurando secrets..."
$FLYCTL_PATH secrets set --app moto \
  SUPABASE_URL="https://zmxigdwkgxirixtmwtwr.supabase.co" \
  SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpteGlnZHdrZ3hpcml4dG13dHdyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMxMjE3MzEsImV4cCI6MjA2ODY5NzczMX0.saLVW4cLUc4cr6125un6rryD51y1e65lDbL8L27oorA" \
  SUPABASE_SERVICE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpteGlnZHdrZ3hpcml4dG13dHdyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MzEyMTczMSwiZXhwIjoyMDY4Njk3NzMxfQ.DEiiKSecLleYx3dZZx0ExqnIzNI_jg_HKjzu9f_E38w" \
  JWT_SECRET="km_dollar_super_secret_jwt_2025_fly_production_key_v1_secure_hash_256" \
  JWT_EXPIRES_IN="7d" \
  JWT_ISSUER="km_dollar_api" \
  DATABASE_URL="postgresql://postgres.zmxigdwkgxirixtmwtwr:[\$&&KM\$@123@]@aws-0-sa-east-1.pooler.supabase.com:5432/postgres"

if [ $? -eq 0 ]; then
    echo "✅ Secrets configurados com sucesso"
else
    echo "❌ Erro ao configurar secrets"
    exit 1
fi

# Fazer deploy
echo "🚀 Fazendo deploy..."
$FLYCTL_PATH deploy --app moto

if [ $? -eq 0 ]; then
    echo "✅ Deploy realizado com sucesso"
else
    echo "❌ Erro no deploy"
    exit 1
fi

# Aguardar um pouco para aplicação subir
echo "⏳ Aguardando aplicação subir..."
sleep 30

# Testar health check
echo "🧪 Testando health check..."
curl -s https://moto.fly.dev/health

# Verificar status
echo "📊 Status da aplicação:"
$FLYCTL_PATH status --app moto

echo ""
echo "🎉 DEPLOY CONCLUÍDO!"
echo "🌐 URL: https://moto.fly.dev"
echo "🔍 Logs: $FLYCTL_PATH logs --app moto"
echo "📱 Pronto para compilar APK!"