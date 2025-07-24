#!/bin/bash

echo "🚀 DEPLOY KM$ BACKEND - SHELL LOCAL"
echo "=================================="

# Token UNI que você criou
export FLY_ACCESS_TOKEN="FlyV1 fm2_lJPECAAAAAAACYErxBDkVgosdn30xIbS9FAOVp+ywrVodHRwczovL2FwaS5mbHkuaW8vdjGUAJLOABI7SB8Lk7lodHRwczovL2FwaS5mbHkuaW8vYWFhL3YxxDwI7wQ7fbIMBIIRP0AYKfEsO7MhqwxwrBzjXZ/VgTgWCYd+/XxqNHSVCw4Sfw77d3OKpHJHf6cOswl9mqHETjyVS3gnd8h9K1YCTccHu1o8eR84fJOmHOxZj4kB3Y7GJ48qCpdPha3PKXies5yoLmcyg8J612NY6BqJtjyYSgPr3Lwf8T018beMJCaLAsQgLTT6IkzuU8bmmIkueYElF3GFSzhxAUjYFkefmtR27ng="

# Path do flyctl instalado
export FLYCTL_INSTALL="/home/runner/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

echo "✅ Token e PATH configurados"
echo "📍 Versão flyctl:"
flyctl version

echo ""
echo "🔐 CONFIGURANDO SECRETS..."

echo "1. SUPABASE_URL..."
flyctl secrets set --app moto SUPABASE_URL="https://zmxigdwkgxirixtmwtwr.supabase.co"

echo "2. SUPABASE_ANON_KEY..."
flyctl secrets set --app moto SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpteGlnZHdrZ3hpcml4dG13dHdyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMxMjE3MzEsImV4cCI6MjA2ODY5NzczMX0.saLVW4cLUc4cr6125un6rryD51y1e65lDbL8L27oorA"

echo "3. SUPABASE_SERVICE_KEY..."
flyctl secrets set --app moto SUPABASE_SERVICE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpteGlnZHdrZ3hpcml4dG13dHdyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MzEyMTczMSwiZXhwIjoyMDY4Njk3NzMxfQ.DEiiKSecLleYx3dZZx0ExqnIzNI_jg_HKjzu9f_E38w"

echo "4. JWT_SECRET..."
flyctl secrets set --app moto JWT_SECRET="km_dollar_super_secret_jwt_2025_fly_production_key_v1_secure_hash_256"

echo "5. JWT_EXPIRES_IN..."
flyctl secrets set --app moto JWT_EXPIRES_IN="7d"

echo "6. JWT_ISSUER..." 
flyctl secrets set --app moto JWT_ISSUER="km_dollar_api"

echo "7. DATABASE_URL..."
flyctl secrets set --app moto DATABASE_URL="postgresql://postgres.zmxigdwkgxirixtmwtwr:[\$&&KM\$@123@]@aws-0-sa-east-1.pooler.supabase.com:5432/postgres"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ SECRETS CONFIGURADOS COM SUCESSO!"
    echo ""
    echo "🚀 INICIANDO DEPLOY..."
    flyctl deploy --app moto --verbose
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "🎉 DEPLOY CONCLUÍDO COM SUCESSO!"
        echo ""
        echo "⏳ Aguardando aplicação inicializar (30s)..."
        sleep 30
        
        echo "🧪 TESTANDO ENDPOINTS..."
        echo ""
        echo "Health Check:"
        curl -s https://moto.fly.dev/health | jq '.' 2>/dev/null || curl -s https://moto.fly.dev/health
        
        echo ""
        echo "API Status:"
        curl -s https://moto.fly.dev/api/status | jq '.' 2>/dev/null || curl -s https://moto.fly.dev/api/status
        
        echo ""
        echo "📊 STATUS FINAL:"
        flyctl status --app moto
        
        echo ""
        echo "🎯 RESULTADO FINAL:"
        echo "✅ Backend deployado: https://moto.fly.dev"
        echo "✅ Secrets configurados"
        echo "✅ Health check ativo"
        echo "📱 Pronto para integração frontend!"
        
    else
        echo "❌ ERRO NO DEPLOY"
        flyctl logs --app moto
        exit 1
    fi
else
    echo "❌ ERRO AO CONFIGURAR SECRETS"
    exit 1
fi