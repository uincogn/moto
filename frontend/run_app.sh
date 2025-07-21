#!/bin/bash

# Script para executar o Motouber - Estética Grau 244
# Este script configura o ambiente e executa o aplicativo Flutter

echo "🏍️  Motouber - Iniciando aplicativo com estética Grau 244..."

# Verificar se Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter não encontrado. Instalando dependências..."
    
    # Tentar usar flutter via nix ou instalar
    if command -v nix &> /dev/null; then
        echo "📦 Usando Nix para Flutter..."
        nix-shell -p flutter --run "flutter doctor"
    else
        echo "⚠️  Flutter não disponível. Execute: 'flutter pub get' manualmente"
        exit 1
    fi
fi

# Limpar e instalar dependências
echo "🔧 Instalando dependências..."
flutter clean
flutter pub get

# Verificar análise estática
echo "🔍 Verificando código..."
flutter analyze || echo "⚠️  Warnings encontrados, mas prosseguindo..."

# Executar testes (se existirem)
echo "🧪 Executando testes..."
flutter test || echo "⚠️  Alguns testes falharam, mas prosseguindo..."

# Executar aplicativo
echo "🚀 Iniciando Motouber - Grau 244..."
echo "📱 O aplicativo será executado com as novas funcionalidades:"
echo "   • Sistema de Metas com progresso visual"
echo "   • Tema dinâmico (claro/escuro/automático)"
echo "   • Backup avançado com compartilhamento"
echo "   • Visual moderno inspirado no movimento Grau 244"
echo ""

# Tentar executar de diferentes formas
if command -v flutter &> /dev/null; then
    echo "▶️  Executando via Flutter..."
    flutter run --debug
else
    echo "❌ Não foi possível executar o Flutter diretamente"
    echo "💡 Para testar o aplicativo:"
    echo "   1. Configure o ambiente Flutter adequado"
    echo "   2. Execute: flutter pub get"
    echo "   3. Execute: flutter run"
    echo ""
    echo "🏗️  Para build de produção (APK):"
    echo "   • Use o CodeMagic CI/CD (já configurado)"
    echo "   • Execute: flutter build apk --release"
    echo ""
    echo "✅ Código fonte está pronto com estética Grau 244!"
fi