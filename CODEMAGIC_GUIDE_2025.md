# 🚀 Guia Completo: Build APK Codemagic + Replit + GitHub (2025)

## 📋 Resumo Executivo

Este guia fornece instruções detalhadas para configurar um pipeline CI/CD completo usando Codemagic, Replit e GitHub para o projeto Motouber Flutter, baseado nas melhores práticas de 2025.

## 🎯 Objetivo

Criar um fluxo automatizado que permita:
- Desenvolver no Replit
- Versionamento no GitHub
- Build automático no Codemagic
- Distribuição de APK para Android

## 🏗️ Arquitetura do Pipeline

```
Replit (Desenvolvimento) → GitHub (Versionamento) → Codemagic (Build) → APK (Distribuição)
```

## 💰 Custos e Planos (2025)

### Codemagic - Plano Gratuito
- **500 minutos/mês** em máquinas macOS M2
- **Build único simultâneo**
- **Repositórios ilimitados**
- **Resetar mensalmente**
- **Ideal para**: Projetos pessoais, protótipos, estudos

### Codemagic - Planos Pagos
- **Pay-as-you-go**: $0.04-$0.10 por minuto
- **Plano Anual macOS M2**: $3,990/ano (3 builds simultâneos)
- **Plano Profissional**: $299/mês (equipes, builds ilimitados)
- **Enterprise**: Preços customizados

### GitHub
- **Gratuito**: Repositórios públicos ilimitados
- **Privados**: Gratuito para uso pessoal
- **Actions**: 2000 minutos/mês gratuitos

### Replit
- **Gratuito**: Desenvolvimento básico
- **Pro**: $20/mês para recursos avançados
- **Deployments**: A partir de $7/mês

## 🚀 Configuração Passo a Passo

### Etapa 1: Configurar Replit para GitHub

#### A. Conectar Replit ao GitHub
1. **Abra seu projeto no Replit**
2. **Clique no ícone Git** (lateral esquerda)
3. **Selecione "Connect to GitHub"**
4. **Autorize a conexão**
5. **Crie ou selecione repositório**

#### B. Configurar .gitignore
```gitignore
# Flutter
/build/
/android/app/debug/
/android/app/profile/
/android/app/release/
*.iml
.gradle/
local.properties
.android/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
/build/
.dart_tool/
.idea/
*.log
.DS_Store
Thumbs.db
```

#### C. Primeiro Push
```bash
# No terminal Replit
git add .
git commit -m "Inicial: Projeto Motouber Flutter"
git push origin main
```

### Etapa 2: Configurar Codemagic

#### A. Criar Conta e Conectar
1. **Acesse**: https://codemagic.io
2. **Clique "Sign up with GitHub"**
3. **Autorize o acesso**
4. **Instale o GitHub App**
5. **Selecione repositório "motouber"**

#### B. Configuração de Projeto
1. **Clique "Add application"**
2. **Escolha "Flutter App"**
3. **Selecione repositório GitHub**
4. **Escolha "Workflow Editor" ou "codemagic.yaml"**

#### C. Configuração Inicial
```yaml
# codemagic.yaml (já incluído no projeto)
workflows:
  android-workflow:
    name: Android APK Build
    max_build_duration: 60
    instance_type: mac_mini_m1
    environment:
      flutter: stable
      xcode: latest
    triggering:
      events:
        - push
        - pull_request
      branch_patterns:
        - pattern: 'main'
        - pattern: 'develop'
    scripts:
      - name: Get Flutter packages
        script: flutter pub get
      - name: Build APK
        script: flutter build apk --release
    artifacts:
      - build/app/outputs/**/*.apk
    publishing:
      email:
        recipients:
          - SEU-EMAIL@gmail.com
```

### Etapa 3: Primeira Build

#### A. Trigger Automático
- **Push para branch main** → Build automático
- **Pull Request** → Build de validação
- **Manual** → Codemagic dashboard

#### B. Monitoramento
```bash
# Stages esperados:
1. "Setting up build environment" (1-2 min)
2. "Getting Flutter packages" (2-3 min)
3. "Flutter analyze" (1 min)
4. "Build APK" (5-10 min)
5. "Publishing artifacts" (1 min)
```

#### C. Tempo Total
- **Primeiro build**: 10-15 minutos
- **Builds subsequentes**: 5-10 minutos
- **Com cache**: 3-5 minutos

## 📱 Máquinas de Build (2025)

### macOS M2 (Recomendado - Gratuito)
- **Tipo**: `mac_mini_m1`
- **Recursos**: 4 CPU, 8GB RAM
- **Ideal para**: Android APK, iOS (se necessário)
- **Custo**: Incluído no plano gratuito

### Linux (Alternativa)
- **Tipo**: `linux_docker`
- **Recursos**: 4 CPU, 8GB RAM
- **Ideal para**: Android APK apenas
- **Custo**: Mais barato que macOS

### Windows (Específico)
- **Tipo**: `windows_x2`
- **Recursos**: 4 CPU, 8GB RAM
- **Ideal para**: Windows desktop apps
- **Custo**: Similar ao Linux

## 🔧 Configurações Avançadas

### A. Otimização de Build
```yaml
scripts:
  - name: Cache Flutter packages
    script: |
      flutter pub get
      flutter pub deps
  - name: Build otimizado
    script: |
      flutter build apk --release --split-per-abi
      # Gera APKs específicos por arquitetura
```

### B. Múltiplas Variantes
```yaml
scripts:
  - name: Build múltiplas versões
    script: |
      flutter build apk --release --flavor prod
      flutter build apk --debug --flavor dev
```

### C. Testes Automatizados
```yaml
scripts:
  - name: Executar testes
    script: |
      flutter test
      flutter test integration_test/
```

## 📊 Monitoramento e Alertas

### A. Notificações Email
```yaml
publishing:
  email:
    recipients:
      - dev@empresa.com
      - mobile@empresa.com
    notify:
      success: true
      failure: true
```

### B. Integração Slack
```yaml
publishing:
  slack:
    channel: '#mobile-builds'
    notify:
      success: true
      failure: true
```

### C. Webhook Personalizado
```yaml
publishing:
  webhooks:
    - name: Build Status
      url: https://api.empresa.com/build-status
      headers:
        Authorization: Bearer $WEBHOOK_TOKEN
```

## 🚨 Troubleshooting Comum

### 1. Build Timeout
```yaml
# Solução: Aumentar timeout
max_build_duration: 90  # 90 minutos
```

### 2. Dependências Falhando
```bash
# Limpar cache
flutter clean
flutter pub get
rm -rf .dart_tool/
```

### 3. Permissões Android
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

### 4. Problemas de Assinatura
```yaml
# Para builds não-assinados
scripts:
  - name: Build APK
    script: flutter build apk --release --no-shrink
```

## 🎯 Otimização do Plano Gratuito

### A. Economizar Minutos
- **Teste localmente** antes de fazer push
- **Use cache eficientemente**
- **Builds incrementais apenas**
- **Evite builds desnecessários**

### B. Estratégias de Branch
```yaml
# Build apenas em branches importantes
triggering:
  events:
    - push
  branch_patterns:
    - pattern: 'main'
    - pattern: 'release/*'
```

### C. Builds Condicionais
```yaml
scripts:
  - name: Build condicional
    script: |
      if [ "$CM_BRANCH" = "main" ]; then
        flutter build apk --release
      else
        flutter build apk --debug
      fi
```

## 🔄 Automatização Completa

### A. Workflow Completo
```
Desenvolvedor → Replit → GitHub → Codemagic → APK → Email → Teste
```

### B. Triggers Automáticos
- **Push main**: Build produção
- **Pull Request**: Build validação
- **Tag v***: Build release
- **Schedule**: Build noturno

### C. Distribuição
```yaml
publishing:
  firebase_app_distribution:
    app_id: $FIREBASE_APP_ID
    groups:
      - testers
      - beta_users
```

## 📋 Checklist de Implementação

### Pré-requisitos
- [ ] Projeto Flutter funcionando no Replit
- [ ] Conta GitHub ativa
- [ ] Conta Codemagic criada
- [ ] Email configurado

### Configuração
- [ ] Repositório GitHub criado
- [ ] Replit conectado ao GitHub
- [ ] Codemagic conectado ao repositório
- [ ] codemagic.yaml configurado
- [ ] Email de notificação configurado

### Validação
- [ ] Primeiro build executado com sucesso
- [ ] APK gerado e baixado
- [ ] Aplicativo instalado e testado
- [ ] Notificações funcionando
- [ ] Pipeline automático funcionando

## 🎉 Resultados Esperados

### APK Final
- **Tamanho**: ~25-30MB
- **Compatibilidade**: Android 5.0+ (API 21+)
- **Arquiteturas**: arm64-v8a, armeabi-v7a
- **Funcionalidades**: Todas testadas e funcionando

### Performance
- **Build time**: 5-10 minutos
- **Deploy automático**: Menos de 1 minuto
- **Notificação**: Instantânea
- **Download**: Link direto no email

## 📚 Recursos Adicionais

### Documentação
- [Codemagic Docs](https://docs.codemagic.io)
- [Flutter CI/CD Guide](https://docs.flutter.dev/deployment/cd)
- [GitHub Actions Flutter](https://github.com/marketplace/actions/flutter-action)

### Comunidade
- [Codemagic Community](https://github.com/codemagic-ci-cd)
- [Flutter Discord](https://discord.gg/flutter)
- [Replit Community](https://replit.com/community)

### Suporte
- **Codemagic**: suporte@codemagic.io
- **GitHub**: support@github.com
- **Replit**: Suporte integrado no app

---

## 🎯 Próximos Passos

1. **Implementar este guia** seguindo cada etapa
2. **Fazer o primeiro build** e validar o APK
3. **Configurar automação completa**
4. **Testar o pipeline** com mudanças reais
5. **Otimizar para produção**

**Status**: Guia atualizado para 2025 com todas as compatibilidades e exigências atuais do Codemagic, GitHub e Replit.

---

**Resultado Final**: Pipeline CI/CD completo, APK Android nativo, distribuição automática! 🚀