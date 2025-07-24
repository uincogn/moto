# 🔧 SOLUÇÃO: FLYCTL PATH PERMANENTE

## 🎯 PROBLEMA IDENTIFICADO
O comando `export PATH="/home/runner/.fly/bin:$PATH"` precisa ser executado toda vez porque:
- Variáveis de ambiente são temporárias na sessão atual
- Quando você fecha o shell, as configurações se perdem
- O PATH volta ao padrão original

## ✅ SOLUÇÃO PERMANENTE

### MÉTODO 1: SCRIPT AUTOMÁTICO (RECOMENDADO)
Execute no seu shell:
```bash
# Baixar e executar o script de configuração
curl -s https://raw.githubusercontent.com/seu-usuario/km-dollar/main/backend/setup_flyctl_permanent.sh | bash
```

### MÉTODO 2: CONFIGURAÇÃO MANUAL
Execute estes comandos **uma única vez**:

```bash
# Adicionar ao .bashrc (bash shell)
echo 'export PATH="/home/runner/.fly/bin:$PATH"' >> ~/.bashrc

# Adicionar ao .profile (compatibilidade geral)
echo 'export PATH="/home/runner/.fly/bin:$PATH"' >> ~/.profile

# Se usar zsh, adicionar também ao .zshrc
echo 'export PATH="/home/runner/.fly/bin:$PATH"' >> ~/.zshrc

# Aplicar imediatamente na sessão atual
source ~/.bashrc
```

### MÉTODO 3: COPIAR E COLAR DIRETO
Copie e cole este bloco completo no seu shell:

```bash
echo 'export PATH="/home/runner/.fly/bin:$PATH"' >> ~/.bashrc && \
echo 'export PATH="/home/runner/.fly/bin:$PATH"' >> ~/.profile && \
source ~/.bashrc && \
echo "✅ flyctl configurado permanentemente!" && \
flyctl version
```

## 🧪 VERIFICAR SE FUNCIONOU

Depois de configurar:
1. **Feche completamente o shell**
2. **Abra novamente** 
3. **Digite**: `flyctl version`
4. **Deve funcionar** sem precisar do export

## 📋 ARQUIVOS MODIFICADOS

A configuração adiciona o PATH aos arquivos:
- `~/.bashrc` - Para shell bash
- `~/.profile` - Para compatibilidade geral  
- `~/.zshrc` - Para shell zsh (se existir)

## ⚡ DEPOIS DE CONFIGURAR

Uma vez feito, você poderá:
```bash
# Usar flyctl diretamente sempre
flyctl version
flyctl auth whoami  
flyctl deploy --app moto
```

## 🎯 PRÓXIMOS PASSOS

1. ✅ Configurar PATH permanente (acima)
2. 🚀 Fazer deploy: `flyctl deploy --app moto`  
3. 🧪 Testar: `curl https://moto.fly.dev/health`
4. 📱 Atualizar frontend para produção

Execute um dos métodos acima e me avise quando o `flyctl version` funcionar sem precisar do export!