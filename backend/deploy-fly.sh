#!/bin/bash

echo "🚀 DEPLOY KM$ BACKEND NO FLY.IO"
echo "================================"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "\n${YELLOW}1. Verificando se Fly CLI está instalado...${NC}"
if ! command -v fly &> /dev/null; then
    echo -e "${RED}❌ Fly CLI não encontrado!${NC}"
    echo "Instale com: curl -L https://fly.io/install.sh | sh"
    exit 1
fi

echo -e "${GREEN}✅ Fly CLI encontrado${NC}"

echo -e "\n${YELLOW}2. Fazendo login no Fly.io...${NC}"
fly auth login

echo -e "\n${YELLOW}3. Configurando secrets do Supabase...${NC}"
echo "Configurando variáveis de ambiente seguras..."

fly secrets set SUPABASE_URL="https://zmxigdwkgxirixtmwtwr.supabase.co"
fly secrets set SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpteGlnZHdrZ3hpcml4dG13dHdyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMxMjE3MzEsImV4cCI6MjA2ODY5NzczMX0.saLVW4cLUc4cr6125un6rryD51y1e65lDbL8L27oorA"
fly secrets set SUPABASE_SERVICE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpteGlnZHdrZ3hpcml4dG13dHdyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MzEyMTczMSwiZXhwIjoyMDY4Njk3NzMxfQ.DEiiKSecLleYx3dZZx0ExqnIzNI_jg_HKjzu9f_E38w"
fly secrets set JWT_SECRET="km_dollar_super_secret_jwt_2025_fly_production_key_v1_secure_hash_256"

echo -e "\n${YELLOW}4. Fazendo deploy...${NC}"
fly deploy

echo -e "\n${YELLOW}5. Verificando status...${NC}"
fly status

echo -e "\n${YELLOW}6. Testando health check...${NC}"
sleep 5
curl -s https://km-dollar.fly.dev/health | jq '.' || echo "Health check não respondeu ainda..."

echo -e "\n${GREEN}✅ DEPLOY CONCLUÍDO!${NC}"
echo -e "🌐 Aplicação disponível em: ${GREEN}https://km-dollar.fly.dev${NC}"
echo -e "🔧 Logs em tempo real: ${YELLOW}fly logs${NC}"
echo -e "📊 Status da aplicação: ${YELLOW}fly status${NC}"
echo -e "⚙️  Configurar mais secrets: ${YELLOW}fly secrets set CHAVE=valor${NC}"

echo -e "\n${YELLOW}📱 PRÓXIMO PASSO:${NC}"
echo "Atualize o frontend para usar a URL: https://km-dollar.fly.dev"
echo "E faça o build do APK via Codemagic"