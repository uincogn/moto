#!/bin/bash

echo "🚀 DEPLOY KM$ BACKEND - PÓS AUTENTICAÇÃO"
echo "======================================="

# Configurar PATH
export PATH="/home/runner/.fly/bin:$PATH"

echo "✅ PATH configurado"

echo "🔍 Verificando autenticação..."
flyctl auth whoami

if [ $? -eq 0 ]; then
    echo "✅ Login confirmado!"
    echo ""
    echo "📊 Status atual do app..."
    flyctl status --app moto
    
    echo ""
    echo "🔐 Configurando secrets essenciais..."
    
    echo "1. SUPABASE_URL..."
    flyctl secrets set --app moto SUPABASE_URL="https://zmxigdwkgxirixtmwtwr.supabase.co"
    
    echo "2. SUPABASE_ANON_KEY..."
    flyctl secrets set --app moto SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpteGlnZHhrZ3hpcml4dG13dHdyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMxMjE3MzEsImV4cCI6MjA2ODY5NzczMX0.saLVW4cLUc4cr6125un6rryD51y1e65lDbL8L27oorA"
    
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
        echo "✅ Secrets configurados!"
        echo ""
        echo "🚀 Iniciando deploy..."
        flyctl deploy --app moto --verbose
        
        if [ $? -eq 0 ]; then
            echo ""
            echo "🎉 DEPLOY REALIZADO COM SUCESSO!"
            echo ""
            echo "⏳ Aguardando aplicação inicializar (30s)..."
            sleep 30
            
            echo "🧪 Testando endpoints..."
            echo ""
            echo "Health Check:"
            curl -s https://moto.fly.dev/health
            
            echo ""
            echo "📊 Status final:"
            flyctl status --app moto
            
            echo ""
            echo "🎯 BACKEND KM$ ONLINE:"
            echo "✅ https://moto.fly.dev"
            echo "✅ Secrets configurados"
            echo "✅ Pronto para frontend!"
            
        else
            echo "❌ Erro no deploy"
            flyctl logs --app moto
            exit 1
        fi
    else
        echo "❌ Erro ao configurar secrets"
        exit 1
    fi
else
    echo "❌ Erro de autenticação - faça login primeiro"
    echo "Execute: flyctl auth login"
    exit 1
fi