#!/bin/bash

echo "🔧 CONFIGURAÇÃO PERMANENTE DO FLYCTL"
echo "==================================="

# Adicionar flyctl ao PATH permanentemente
echo 'export PATH="/home/runner/.fly/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="/home/runner/.fly/bin:$PATH"' >> ~/.profile

# Adicionar ao zshrc se existir
if [ -f ~/.zshrc ]; then
    echo 'export PATH="/home/runner/.fly/bin:$PATH"' >> ~/.zshrc
fi

echo "✅ PATH adicionado aos arquivos de configuração"
echo ""
echo "🔄 Para aplicar imediatamente, execute:"
echo "source ~/.bashrc"
echo ""
echo "📋 Ou simplesmente feche e abra o shell novamente"
echo ""
echo "🧪 Teste se funcionou:"
echo "flyctl version"