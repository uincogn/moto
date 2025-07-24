#!/bin/bash

echo "🚀 DEPLOY MINIMAL VIA SHELL"
echo "=========================="

echo "❌ Token atual com problema de autenticação"
echo "📝 Comandos para executar MANUALMENTE:"
echo ""
echo "1️⃣ INSTALAR FLYCTL (se necessário):"
echo "curl -L https://fly.io/install.sh | sh"
echo ""
echo "2️⃣ FAZER LOGIN:"
echo "fly auth login"
echo ""
echo "3️⃣ CONFIGURAR SECRETS:"
echo 'fly secrets set --app moto SUPABASE_URL="https://zmxigdwkgxirixtmwtwr.supabase.co"'
echo 'fly secrets set --app moto SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpteGlnZHdrZ3hpcml4dG13dHdyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMxMjE3MzEsImV4cCI6MjA2ODY5NzczMX0.saLVW4cLUc4cr6125un6rryD51y1e65lDbL8L27oorA"'
echo 'fly secrets set --app moto SUPABASE_SERVICE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpteGlnZHdrZ3hpcml4dG13dHdyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MzEyMTczMSwiZXhwIjoyMDY4Njk3NzMxfQ.DEiiKSecLleYx3dZZx0ExqnIzNI_jg_HKjzu9f_E38w"'
echo 'fly secrets set --app moto JWT_SECRET="km_dollar_super_secret_jwt_2025_fly_production_key_v1_secure_hash_256"'
echo 'fly secrets set --app moto JWT_EXPIRES_IN="7d"'
echo 'fly secrets set --app moto JWT_ISSUER="km_dollar_api"'
echo ""
echo "4️⃣ FAZER DEPLOY:"
echo "fly deploy --app moto"
echo ""
echo "5️⃣ TESTAR:"
echo "curl https://moto.fly.dev/health"
echo ""
echo "🎯 PROBLEMA: Tokens nos workflows precisam de refresh"
echo "💡 SOLUÇÃO: Fazer login manual com 'fly auth login'"
echo ""
echo "📱 Alternativa Web Dashboard:"
echo "1. Acesse: https://fly.io/apps/moto"
echo "2. Configure secrets no painel"
echo "3. Clique em Deploy"