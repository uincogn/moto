#!/bin/bash

echo "🚀 DEPLOY COM TOKEN UNI - MÉTODO OFICIAL FLY.IO"
echo "==============================================="

# Token UNI criado pelo usuário
export FLY_ACCESS_TOKEN="FlyV1 fm2_lJPECAAAAAAACYErxBDkVgosdn30xIbS9FAOVp+ywrVodHRwczovL2FwaS5mbHkuaW8vdjGUAJLOABI7SB8Lk7lodHRwczovL2FwaS5mbHkuaW8vYWFhL3YxxDwI7wQ7fbIMBIIRP0AYKfEsO7MhqwxwrBzjXZ/VgTgWCYd+/XxqNHSVCw4Sfw77d3OKpHJHf6cOswl9mqHETjyVS3gnd8h9K1YCTccHu1o8eR84fJOmHOxZj4kB3Y7GJ48qCpdPha3PKXies5yoLmcyg8J612NY6BqJtjyYSgPr3Lwf8T018beMJCaLAsQgLTT6IkzuU8bmmIkueYElF3GFSzhxAUjYFkefmtR27ng="

echo "✅ Token UNI configurado"

# Flyctl path
FLYCTL="/home/runner/.fly/bin/flyctl"

echo "🔍 Testando token com version..."
$FLYCTL version

echo ""
echo "🔐 Configurando secrets primeiro..."

echo "Configurando SUPABASE_URL..."
$FLYCTL secrets set --app moto SUPABASE_URL="https://zmxigdwkgxirixtmwtwr.supabase.co"

echo "Configurando SUPABASE_ANON_KEY..."
$FLYCTL secrets set --app moto SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpteGlnZHdrZ3hpcml4dG13dHdyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMxMjE3MzEsImV4cCI6MjA2ODY5NzczMX0.saLVW4cLUc4cr6125un6rryD51y1e65lDbL8L27oorA"

echo "Configurando SUPABASE_SERVICE_KEY..."
$FLYCTL secrets set --app moto SUPABASE_SERVICE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpteGlnZHdrZ3hpcml4dG13dHdyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MzEyMTczMSwiZXhwIjoyMDY4Njk3NzMxfQ.DEiiKSecLleYx3dZZx0ExqnIzNI_jg_HKjzu9f_E38w"

echo "Configurando JWT_SECRET..."
$FLYCTL secrets set --app moto JWT_SECRET="km_dollar_super_secret_jwt_2025_fly_production_key_v1_secure_hash_256"

echo "Configurando JWT_EXPIRES_IN..."
$FLYCTL secrets set --app moto JWT_EXPIRES_IN="7d"

echo "Configurando JWT_ISSUER..."
$FLYCTL secrets set --app moto JWT_ISSUER="km_dollar_api"

echo "Configurando DATABASE_URL..."
$FLYCTL secrets set --app moto DATABASE_URL="postgresql://postgres.zmxigdwkgxirixtmwtwr:[\$&&KM\$@123@]@aws-0-sa-east-1.pooler.supabase.com:5432/postgres"

if [ $? -eq 0 ]; then
    echo "✅ Secrets configurados com sucesso!"
    echo ""
    echo "🚀 Fazendo deploy..."
    $FLYCTL deploy --app moto
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ DEPLOY REALIZADO COM SUCESSO!"
        echo ""
        echo "⏳ Aguardando 30 segundos para aplicação subir..."
        sleep 30
        
        echo "🧪 Testando health check..."
        curl -s https://moto.fly.dev/health
        
        echo ""
        echo "📊 Status final:"
        $FLYCTL status --app moto
        
        echo ""
        echo "🎉 SUCESSO TOTAL!"
        echo "🌐 Backend disponível em: https://moto.fly.dev"
        echo "📱 Pronto para compilar APK no frontend!"
    else
        echo "❌ Erro no deploy"
        exit 1
    fi
else
    echo "❌ Erro ao configurar secrets"
    exit 1
fi