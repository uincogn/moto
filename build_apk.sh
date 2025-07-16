#!/bin/bash

# Script para compilar APK do Motouber no VPS
# Certifique-se de que o Flutter e Android SDK estão instalados

echo "🚀 Iniciando build do APK Motouber..."

# Verificar se Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter não encontrado. Instale primeiro:"
    echo "git clone https://github.com/flutter/flutter.git"
    echo "export PATH=\"\$PATH:\`pwd\`/flutter/bin\""
    exit 1
fi

# Verificar se Android SDK está configurado
if [ -z "$ANDROID_HOME" ]; then
    echo "❌ ANDROID_HOME não configurado"
    exit 1
fi

# Limpar cache
echo "🧹 Limpando cache..."
flutter clean

# Instalar dependências
echo "📦 Instalando dependências..."
flutter pub get

# Verificar se tudo está ok
echo "🔍 Verificando configuração..."
flutter doctor

# Build do APK
echo "🔨 Compilando APK..."
flutter build apk --release

# Verificar se build foi bem-sucedido
if [ $? -eq 0 ]; then
    echo "✅ APK compilado com sucesso!"
    echo "📱 Localização: build/app/outputs/flutter-apk/app-release.apk"
    
    # Mostrar informações do APK
    if command -v aapt &> /dev/null; then
        echo "📊 Informações do APK:"
        aapt dump badging build/app/outputs/flutter-apk/app-release.apk | grep -E "package:|versionCode:|versionName:|sdkVersion:"
    fi
    
    # Mostrar tamanho do arquivo
    echo "📏 Tamanho do APK: $(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)"
else
    echo "❌ Erro na compilação do APK"
    exit 1
fi

echo "🎉 Build concluído!"