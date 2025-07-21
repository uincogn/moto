#!/bin/bash

# Script para validar configuração do projeto Motouber
# Execute: chmod +x validate_project.sh && ./validate_project.sh

echo "🔍 Validando configuração do projeto Motouber..."
echo "================================================="

# Verificar arquivos essenciais
echo "📁 Verificando arquivos essenciais..."
required_files=(
    "pubspec.yaml"
    "codemagic.yaml"
    "lib/main.dart"
    "android/app/build.gradle"
    "android/app/src/main/AndroidManifest.xml"
    ".gitignore"
    "README.md"
    "replit.md"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file encontrado"
    else
        echo "❌ $file não encontrado"
    fi
done

# Verificar dependências Flutter
echo ""
echo "📦 Verificando dependências Flutter..."
if command -v flutter &> /dev/null; then
    echo "✅ Flutter CLI encontrado"
    flutter --version | head -1
    
    echo ""
    echo "🔧 Executando flutter doctor..."
    flutter doctor
    
    echo ""
    echo "📋 Verificando dependências do projeto..."
    flutter pub get
    
    echo ""
    echo "🔍 Analisando código..."
    flutter analyze
    
else
    echo "❌ Flutter CLI não encontrado"
    echo "   Instale: https://flutter.dev/docs/get-started/install"
fi

# Verificar configuração Android
echo ""
echo "🤖 Verificando configuração Android..."
if [ -f "android/app/build.gradle" ]; then
    echo "✅ android/app/build.gradle encontrado"
    
    # Verificar versões SDK
    compile_sdk=$(grep "compileSdkVersion" android/app/build.gradle | grep -o '[0-9]\+')
    target_sdk=$(grep "targetSdkVersion" android/app/build.gradle | grep -o '[0-9]\+')
    min_sdk=$(grep "minSdkVersion" android/app/build.gradle | grep -o '[0-9]\+')
    
    echo "   compileSdkVersion: $compile_sdk"
    echo "   targetSdkVersion: $target_sdk"
    echo "   minSdkVersion: $min_sdk"
    
    if [ "$compile_sdk" -eq 34 ] && [ "$target_sdk" -eq 34 ] && [ "$min_sdk" -eq 21 ]; then
        echo "✅ Versões SDK corretas (2025)"
    else
        echo "⚠️  Versões SDK podem estar desatualizadas"
    fi
else
    echo "❌ android/app/build.gradle não encontrado"
fi

# Verificar configuração Codemagic
echo ""
echo "🔧 Verificando configuração Codemagic..."
if [ -f "codemagic.yaml" ]; then
    echo "✅ codemagic.yaml encontrado"
    
    # Verificar triggers
    if grep -q "triggering:" codemagic.yaml; then
        echo "✅ Triggers configurados"
    else
        echo "⚠️  Triggers não configurados"
    fi
    
    # Verificar artifacts
    if grep -q "artifacts:" codemagic.yaml; then
        echo "✅ Artifacts configurados"
    else
        echo "⚠️  Artifacts não configurados"
    fi
    
    # Verificar email
    if grep -q "email:" codemagic.yaml; then
        echo "✅ Notificações email configuradas"
    else
        echo "⚠️  Email não configurado"
    fi
else
    echo "❌ codemagic.yaml não encontrado"
fi

# Verificar estrutura de pastas
echo ""
echo "📂 Verificando estrutura de pastas..."
required_dirs=(
    "lib"
    "lib/models"
    "lib/services"
    "lib/screens"
    "lib/theme"
    "android"
    "assets"
    "assets/images"
    "assets/icons"
)

for dir in "${required_dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo "✅ $dir/"
    else
        echo "❌ $dir/ não encontrado"
    fi
done

# Verificar Git
echo ""
echo "🔄 Verificando configuração Git..."
if [ -d ".git" ]; then
    echo "✅ Repositório Git inicializado"
    
    # Verificar remote
    if git remote -v &> /dev/null; then
        echo "✅ Remote configurado:"
        git remote -v
    else
        echo "⚠️  Remote não configurado"
        echo "   Configure: git remote add origin https://github.com/SEU-USUARIO/motouber.git"
    fi
    
    # Verificar status
    echo ""
    echo "📊 Status do repositório:"
    git status --porcelain | head -10
    
else
    echo "❌ Repositório Git não inicializado"
    echo "   Execute: git init"
fi

# Verificar .gitignore
echo ""
echo "🚫 Verificando .gitignore..."
if [ -f ".gitignore" ]; then
    echo "✅ .gitignore encontrado"
    
    # Verificar entradas importantes
    important_ignores=(
        "/build/"
        ".dart_tool/"
        ".packages"
        "*.log"
        ".replit"
        ".DS_Store"
    )
    
    for ignore in "${important_ignores[@]}"; do
        if grep -q "$ignore" .gitignore; then
            echo "✅ $ignore ignorado"
        else
            echo "⚠️  $ignore não ignorado"
        fi
    done
else
    echo "❌ .gitignore não encontrado"
fi

# Teste de build
echo ""
echo "🔨 Teste de build..."
if command -v flutter &> /dev/null; then
    echo "Executando flutter build apk --debug..."
    if flutter build apk --debug; then
        echo "✅ Build APK debug bem-sucedido"
    else
        echo "❌ Build APK debug falhou"
    fi
else
    echo "⚠️  Flutter CLI não disponível - pule este teste"
fi

# Resumo final
echo ""
echo "📋 RESUMO DA VALIDAÇÃO"
echo "====================="
echo "1. Verifique os itens marcados com ❌ acima"
echo "2. Configure os itens marcados com ⚠️  se necessário"
echo "3. Execute flutter pub get para atualizar dependências"
echo "4. Execute flutter analyze para verificar código"
echo "5. Conecte ao GitHub e configure Codemagic"
echo ""
echo "📚 Documentação disponível:"
echo "   - README.md - Instruções gerais"
echo "   - REPLIT_SETUP.md - Configuração Replit"
echo "   - CODEMAGIC_GUIDE_2025.md - Guia CI/CD completo"
echo "   - REPLIT_GITHUB_INTEGRATION.md - Integração completa"
echo ""
echo "🎯 Próximos passos:"
echo "   1. Corrigir itens com ❌"
echo "   2. Conectar Replit ao GitHub"
echo "   3. Configurar Codemagic"
echo "   4. Fazer primeiro build automático"
echo ""
echo "✅ Validação concluída!"