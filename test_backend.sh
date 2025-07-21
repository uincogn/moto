#!/bin/bash

echo "🧪 TESTANDO BACKEND KM$ - SUPABASE + JWT"
echo "========================================"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "\n${YELLOW}1. Testando Health Check...${NC}"
curl -s http://localhost:3000/health | jq '.'

echo -e "\n${YELLOW}2. Testando Registro de Usuário...${NC}"
REGISTER_RESPONSE=$(curl -s -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "teste@kmdollar.com",
    "password": "123456",
    "name": "Usuario Teste KM$"
  }')

echo $REGISTER_RESPONSE | jq '.'

# Extrair token se registro foi bem-sucedido
TOKEN=$(echo $REGISTER_RESPONSE | jq -r '.token // empty')

if [ ! -z "$TOKEN" ] && [ "$TOKEN" != "null" ]; then
    echo -e "\n${GREEN}✅ Registro bem-sucedido! Token recebido.${NC}"
    
    echo -e "\n${YELLOW}3. Testando rota protegida /me...${NC}"
    curl -s -H "Authorization: Bearer $TOKEN" \
         -H "Content-Type: application/json" \
         http://localhost:3000/api/auth/me | jq '.'
else
    echo -e "\n${RED}❌ Falha no registro. Testando login com usuário existente...${NC}"
fi

echo -e "\n${YELLOW}4. Testando Login...${NC}"
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "teste@kmdollar.com",
    "password": "123456"
  }')

echo $LOGIN_RESPONSE | jq '.'

# Extrair token do login
LOGIN_TOKEN=$(echo $LOGIN_RESPONSE | jq -r '.token // empty')

if [ ! -z "$LOGIN_TOKEN" ] && [ "$LOGIN_TOKEN" != "null" ]; then
    echo -e "\n${GREEN}✅ Login bem-sucedido!${NC}"
    
    echo -e "\n${YELLOW}5. Testando rota protegida /me com token de login...${NC}"
    curl -s -H "Authorization: Bearer $LOGIN_TOKEN" \
         -H "Content-Type: application/json" \
         http://localhost:3000/api/auth/me | jq '.'
else
    echo -e "\n${RED}❌ Falha no login.${NC}"
fi

echo -e "\n${YELLOW}6. Testando rota protegida SEM token (deve dar erro)...${NC}"
curl -s http://localhost:3000/api/auth/me | jq '.'

echo -e "\n🎯 ${GREEN}TESTES CONCLUÍDOS!${NC}"
echo "Se você viu tokens JWT e dados de usuário, está tudo funcionando! ✅"