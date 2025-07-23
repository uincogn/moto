#!/bin/bash

# 🧪 Script de Teste do Backend KM$ no Fly.io
# Executa todos os testes necessários para validar o backend

echo "🚀 KM$ Backend - Teste Completo"
echo "================================"

BASE_URL="https://moto.fly.dev"
echo "🌐 Testando: $BASE_URL"
echo ""

# 1. Health Check
echo "1️⃣ HEALTH CHECK"
echo "----------------"
response=$(curl -s -w "%{http_code}" "$BASE_URL/health" -o /tmp/health_response.json)
http_code="${response: -3}"

if [ "$http_code" = "200" ]; then
    echo "✅ Health check: OK ($http_code)"
    echo "📄 Resposta: $(cat /tmp/health_response.json)"
else
    echo "❌ Health check: FALHA ($http_code)"
    echo "📄 Resposta: $(cat /tmp/health_response.json)"
fi
echo ""

# 2. Registro de Usuário
echo "2️⃣ REGISTRO DE USUÁRIO"
echo "----------------------"
timestamp=$(date +%s)
test_email="teste$timestamp@fly.dev"

register_response=$(curl -s -w "%{http_code}" -X POST "$BASE_URL/api/auth/register" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"Teste Deploy\",\"email\":\"$test_email\",\"password\":\"123456\"}" \
  -o /tmp/register_response.json)
register_code="${register_response: -3}"

if [ "$register_code" = "201" ] || [ "$register_code" = "200" ]; then
    echo "✅ Registro: OK ($register_code)"
    echo "📄 Resposta: $(cat /tmp/register_response.json)"
    
    # Extrair token se presente
    token=$(cat /tmp/register_response.json | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
    if [ ! -z "$token" ]; then
        echo "🔑 Token obtido: ${token:0:20}..."
    fi
else
    echo "❌ Registro: FALHA ($register_code)"
    echo "📄 Resposta: $(cat /tmp/register_response.json)"
fi
echo ""

# 3. Login
echo "3️⃣ LOGIN"
echo "---------"
login_response=$(curl -s -w "%{http_code}" -X POST "$BASE_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$test_email\",\"password\":\"123456\"}" \
  -o /tmp/login_response.json)
login_code="${login_response: -3}"

if [ "$login_code" = "200" ]; then
    echo "✅ Login: OK ($login_code)"
    echo "📄 Resposta: $(cat /tmp/login_response.json)"
    
    # Extrair token de login
    login_token=$(cat /tmp/login_response.json | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
    if [ ! -z "$login_token" ]; then
        echo "🔑 Token login: ${login_token:0:20}..."
    fi
else
    echo "❌ Login: FALHA ($login_code)"
    echo "📄 Resposta: $(cat /tmp/login_response.json)"
fi
echo ""

# 4. Teste com Token (se disponível)
if [ ! -z "$login_token" ]; then
    echo "4️⃣ TESTE AUTENTICADO"
    echo "--------------------"
    auth_response=$(curl -s -w "%{http_code}" -X GET "$BASE_URL/api/auth/me" \
      -H "Authorization: Bearer $login_token" \
      -o /tmp/auth_response.json)
    auth_code="${auth_response: -3}"
    
    if [ "$auth_code" = "200" ]; then
        echo "✅ Endpoint autenticado: OK ($auth_code)"
        echo "📄 Resposta: $(cat /tmp/auth_response.json)"
    else
        echo "❌ Endpoint autenticado: FALHA ($auth_code)"
        echo "📄 Resposta: $(cat /tmp/auth_response.json)"
    fi
    echo ""
fi

# 5. Resumo Final
echo "📊 RESUMO FINAL"
echo "==============="
if [ "$http_code" = "200" ]; then
    echo "✅ Health Check: FUNCIONANDO"
else
    echo "❌ Health Check: FALHA"
fi

if [ "$register_code" = "201" ] || [ "$register_code" = "200" ]; then
    echo "✅ Registro: FUNCIONANDO"
else
    echo "❌ Registro: FALHA"
fi

if [ "$login_code" = "200" ]; then
    echo "✅ Login: FUNCIONANDO"
else
    echo "❌ Login: FALHA"
fi

# Conclusão
if [ "$http_code" = "200" ] && ([ "$register_code" = "200" ] || [ "$register_code" = "201" ]) && [ "$login_code" = "200" ]; then
    echo ""
    echo "🎉 BACKEND 100% FUNCIONAL!"
    echo "✅ Pronto para compilar APK e testar integração"
    echo "📱 URL do backend: $BASE_URL"
else
    echo ""
    echo "⚠️ BACKEND COM PROBLEMAS"
    echo "🔧 Verificar logs do Fly.io para mais detalhes"
fi

# Limpeza
rm -f /tmp/health_response.json /tmp/register_response.json /tmp/login_response.json /tmp/auth_response.json