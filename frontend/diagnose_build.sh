#!/bin/bash

echo "=== DIAGNÓSTICO DO PROBLEMA DE BUILD ==="
echo "Verificando configurações Android..."

# Verificar se há arquivos conflitantes
echo "1. Verificando arquivos de recursos..."
find android/app/src/main/res -type f | sort

echo -e "\n2. Verificando permissões..."
ls -la android/gradlew

echo -e "\n3. Verificando configurações Gradle..."
grep -n "compileSdk\|targetSdk\|minSdk" android/app/build.gradle

echo -e "\n4. Verificando dependências problemáticas..."
grep -E "file_picker|permission_handler|share_plus|path_provider" pubspec.yaml

echo -e "\n5. Verificando namespace..."
grep -n "namespace\|applicationId" android/app/build.gradle

echo -e "\n=== DIAGNÓSTICO COMPLETO ==="