#!/bin/bash

# Script para configurar ambiente Flutter no VPS Ubuntu
# Execute como usuário normal (não root)

echo "🔧 Configurando ambiente Flutter no VPS..."

# Atualizar sistema
echo "📦 Atualizando sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar dependências básicas
echo "🛠️ Instalando dependências..."
sudo apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-17-jdk

# Configurar JAVA_HOME
echo "☕ Configurando Java..."
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
echo "export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64" >> ~/.bashrc

# Baixar e instalar Flutter
echo "🐦 Instalando Flutter..."
cd ~
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:`pwd`/flutter/bin"
echo "export PATH=\"\$PATH:\`pwd\`/flutter/bin\"" >> ~/.bashrc

# Baixar e instalar Android SDK
echo "🤖 Instalando Android SDK..."
mkdir -p ~/android-sdk
cd ~/android-sdk
wget https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip
unzip commandlinetools-linux-10406996_latest.zip
rm commandlinetools-linux-10406996_latest.zip

# Configurar Android SDK
export ANDROID_HOME=~/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/bin:$ANDROID_HOME/platform-tools
echo "export ANDROID_HOME=~/android-sdk" >> ~/.bashrc
echo "export PATH=\$PATH:\$ANDROID_HOME/cmdline-tools/bin:\$ANDROID_HOME/platform-tools" >> ~/.bashrc

# Aceitar licenças e instalar componentes
echo "📝 Aceitando licenças Android..."
cd ~/android-sdk/cmdline-tools/bin
yes | ./sdkmanager --sdk_root=$ANDROID_HOME --licenses
./sdkmanager --sdk_root=$ANDROID_HOME "platform-tools" "platforms;android-33" "build-tools;33.0.0"

# Configurar Flutter
echo "⚙️ Configurando Flutter..."
cd ~
flutter config --android-sdk $ANDROID_HOME
flutter doctor --android-licenses

# Verificar instalação
echo "🔍 Verificando instalação..."
flutter doctor

echo "✅ Configuração concluída!"
echo "🔄 Reinicie o terminal ou execute: source ~/.bashrc"
echo "📱 Agora você pode compilar APKs Flutter no VPS!"