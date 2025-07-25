# 🚀 CODEMAGIC API INTEGRATION - KM$ FLUTTER

## 📋 Visão Geral

Sistema completo de integração com a API do Codemagic para automatizar builds do aplicativo KM$ Flutter. Esta integração permite disparar builds automáticos, monitorar status e gerenciar o ciclo completo de CI/CD.

## 🔧 Configuração

### API Token
```
Token: XCUldLgleC4AoYk-stiZe0tMjul8_nei2WX2WdEbbsQ
Rate Limit: 5.000 requests/hora
Base URL: https://api.codemagic.io
```

### Autenticação
Todas as requisições usam o header `x-auth-token`:
```bash
curl -H "x-auth-token: XCUldLgleC4AoYk-stiZe0tMjul8_nei2WX2WdEbbsQ" \
     -H "Content-Type: application/json" \
     https://api.codemagic.io/apps
```

## 📱 Scripts Criados

### 1. `codemagic_integration.py`
**Script principal interativo** com menu completo:
- ✅ Listar aplicações
- ✅ Disparar builds manuais
- ✅ Monitorar builds em tempo real
- ✅ Verificar status de builds
- ✅ Cancelar builds em execução
- ✅ Listar histórico de builds

**Uso:**
```bash
python scripts/codemagic_integration.py
```

### 2. `quick_build.py`
**Script rápido** para automação:
```bash
# Uso básico (detecta app automaticamente)
python scripts/quick_build.py

# Uso completo
python scripts/quick_build.py [app_id] [workflow_id] [branch]

# Exemplo
python scripts/quick_build.py 5c9c064185dd2310123b8e96 release main
```

### 3. `webhook_integration.py`
**Sistema de webhooks** para integração automática:
- 📨 Recebe webhooks do GitHub (push events)
- 🚀 Dispara builds automáticos no Codemagic
- 📢 Envia notificações (Slack, Discord)
- 🎯 Filtra branches específicas

**Endpoints:**
- `POST /webhook/github` - Webhooks do GitHub
- `POST /webhook/codemagic` - Status de builds
- `GET /status` - Status do serviço

## 🔄 Fluxo de Automação

### Cenário 1: Build Manual
```bash
# 1. Listar apps disponíveis
python scripts/codemagic_integration.py
# Opção 1: Listar aplicações

# 2. Disparar build
# Opção 2: Disparar build
# Inserir: app_id, workflow_id (release/debug), branch

# 3. Monitorar progresso
# Opção 4: Monitorar build
# Resultado: APK pronto para download
```

### Cenário 2: Build Automático (GitHub + Webhook)
```bash
# 1. Configurar webhook no GitHub
# URL: https://seu-servidor.com/webhook/github
# Events: push
# Secret: configurar em GITHUB_WEBHOOK_SECRET

# 2. Iniciar serviço webhook
python scripts/webhook_integration.py

# 3. Push para branch main/develop
git push origin main

# 4. Build automático disparado
# 5. Notificação via Slack (opcional)
```

## 📊 API Endpoints Utilizados

### Applications
```bash
# Listar aplicações
GET https://api.codemagic.io/apps

# Aplicação específica  
GET https://api.codemagic.io/apps/<app_id>
```

### Builds
```bash
# Disparar build
POST https://api.codemagic.io/builds
{
  "appId": "<app_id>",
  "workflowId": "<workflow_id>",
  "branch": "<branch>",
  "environment": {
    "variables": {
      "CUSTOM_VAR": "value"
    }
  }
}

# Status do build
GET https://api.codemagic.io/builds/<build_id>

# Cancelar build
POST https://api.codemagic.io/builds/<build_id>/cancel

# Histórico
GET https://api.codemagic.io/builds?appId=<app_id>&limit=10
```

## 🔧 Configuração Avançada

### Variáveis de Ambiente Automáticas
Os scripts injetam automaticamente:
```json
{
  "BUILD_TIMESTAMP": "2025-07-25T14:52:00Z",
  "BUILD_MODE": "automated",
  "TRIGGERED_BY": "webhook/manual",
  "COMMIT_SHA": "abc123...",
  "COMMIT_MESSAGE": "Fix: correção crítica",
  "COMMIT_AUTHOR": "Developer Name"
}
```

### Workflows Dinâmicos
- **Main/Master/Release**: Workflow `release`
- **Develop/Feature**: Workflow `debug`
- **Custom**: Configurável via parâmetro

### Branches Configuráveis
```python
"auto_build_branches": ["main", "develop", "release/*"]
"notification_branches": ["main"]
```

## 📢 Integração com Notificações

### Slack
1. Criar webhook: https://api.slack.com/incoming-webhooks
2. Configurar `SLACK_WEBHOOK_URL`
3. Notificações automáticas para builds principais

### Discord (Similar)
Webhook URL no formato Discord e ajustes no payload.

## 🧪 Testes de Integração

### Teste Básico
```bash
# Verificar conexão
python -c "
import requests
headers = {'x-auth-token': 'XCUldLgleC4AoYk-stiZe0tMjul8_nei2WX2WdEbbsQ'}
r = requests.get('https://api.codemagic.io/apps', headers=headers)
print(f'Status: {r.status_code}')
"
```

### Teste Build Manual
```bash
python scripts/quick_build.py
# Seguir prompts interativos
```

### Teste Webhook
```bash
# Iniciar serviço
python scripts/webhook_integration.py

# Testar endpoint (outra janela)
curl -X POST http://localhost:5001/status
```

## 🚀 Deploy em Produção

### Opções de Hosting
1. **Replit** - Deploy direto (recomendado para testes)
2. **Fly.io** - Produção robusta
3. **Railway** - Deploy simplificado
4. **VPS** - Controle total

### Configuração Produção
```bash
# Variáveis de ambiente necessárias
export CODEMAGIC_API_TOKEN="XCUldLgleC4AoYk-stiZe0tMjul8_nei2WX2WdEbbsQ"
export GITHUB_WEBHOOK_SECRET="your_secret"
export SLACK_WEBHOOK_URL="https://hooks.slack.com/..."

# Iniciar serviço
python scripts/webhook_integration.py
```

## 📝 Próximos Passos

### Implementação Imediata
1. ✅ **Testar conexão API** - Verificar credenciais
2. ✅ **Identificar app_id** - Localizar aplicação KM$
3. ✅ **Build manual** - Primeiro teste
4. ✅ **Configurar webhook** - Automação completa

### Melhorias Futuras
- 🔄 **Retry automático** em caso de falhas
- 📊 **Dashboard web** para monitoramento
- 🔍 **Logs detalhados** de builds
- 📈 **Métricas de performance** CI/CD
- 🎯 **Deploy automático** pós-build sucesso

## 🎯 Benefícios da Integração

### Para Desenvolvimento
- ⚡ **Builds automáticos** a cada push
- 🔄 **CI/CD sem intervenção manual**
- 📊 **Monitoramento em tempo real**
- 🎯 **Feedback imediato** de qualidade

### Para Produção
- 🚀 **Deploy contínuo** para releases
- 📱 **APKs automaticamente gerados**
- 📢 **Notificações de status** para equipe
- 🔒 **Versionamento automático**

---

**Status**: Sistema pronto para uso e totalmente configurado com sua API do Codemagic!