# 🔄 Guia: Integração Replit → GitHub → Codemagic (2025)

## 📋 Visão Geral

Este guia detalha como configurar a integração completa entre Replit (desenvolvimento), GitHub (versionamento) e Codemagic (build automático) para o projeto Motouber Flutter.

## 🎯 Fluxo de Trabalho

```
Replit (Código) → GitHub (Git) → Codemagic (Build) → APK (Produto)
```

## 🚀 Configuração Replit → GitHub

### Passo 1: Preparar Projeto no Replit

#### A. Verificar Estrutura
```bash
# Estrutura necessária:
motouber/
├── lib/                 # Código Flutter
├── android/             # Configurações Android
├── pubspec.yaml         # Dependências
├── codemagic.yaml       # CI/CD Config
├── README.md            # Documentação
└── .gitignore           # Arquivos ignorados
```

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

# Replit
.replit
replit.nix
.upm/
.cache/
venv/

# Sistema
.DS_Store
Thumbs.db
*.swp
*.swo
*~
```

### Passo 2: Conectar ao GitHub

#### A. Método Via Interface Replit
1. **Abra o projeto no Replit**
2. **Clique no ícone Git** (barra lateral)
3. **Selecione "Connect to GitHub"**
4. **Autorize a conexão**
5. **Crie novo repositório ou conecte existente**

#### B. Método Via URL Rápida
```bash
# Para importar do GitHub para Replit:
https://replit.com/github/SEU-USUARIO/motouber

# Para criar do zero:
https://replit.com/new/github
```

#### C. Configuração Manual (Terminal)
```bash
# No terminal Replit
git init
git add .
git commit -m "Initial commit: Motouber Flutter App"
git remote add origin https://github.com/SEU-USUARIO/motouber.git
git branch -M main
git push -u origin main
```

### Passo 3: Configurar Webhook

#### A. Configuração Automática
- **Replit detecta automaticamente** mudanças
- **Push automático** quando configurado
- **Sync bidirecional** disponível

#### B. Configuração Manual
```bash
# Configurar auto-push
git config --global user.name "Seu Nome"
git config --global user.email "seu@email.com"
git config push.default simple
```

## 🔧 Configuração GitHub → Codemagic

### Passo 1: Preparar Repositório GitHub

#### A. Verificar Arquivos Essenciais
```bash
# Arquivos obrigatórios na raiz:
├── pubspec.yaml         # Dependências Flutter
├── codemagic.yaml       # Configuração CI/CD
├── android/             # Configurações Android
└── lib/                 # Código fonte
```

#### B. Configurar Branch Protection
```yaml
# GitHub Settings → Branches → Add rule
Branch name pattern: main
☑️ Require pull request reviews
☑️ Require status checks to pass
☑️ Require up-to-date branches
```

### Passo 2: Conectar ao Codemagic

#### A. Instalação GitHub App
1. **Acesse**: https://codemagic.io/start/
2. **Clique "Sign up with GitHub"**
3. **Autorize o acesso**
4. **Instale Codemagic GitHub App**:
   - Vá para: https://github.com/apps/codemagic-ci-cd
   - Clique "Install"
   - Selecione repositórios ou "All repositories"

#### B. Configuração de Projeto
```yaml
# Codemagic detecta automaticamente:
- Flutter project type
- Dependencies em pubspec.yaml
- Android configuration
- Branch patterns
```

### Passo 3: Configurar Triggers

#### A. Webhook Automático
```yaml
# codemagic.yaml
triggering:
  events:
    - push          # Build em push
    - pull_request  # Build em PR
    - tag           # Build em tag
  branch_patterns:
    - pattern: 'main'
      include: true
    - pattern: 'develop'
      include: true
    - pattern: 'feature/*'
      include: false
```

#### B. Configuração Manual
```bash
# GitHub Settings → Webhooks
Payload URL: https://api.codemagic.io/hooks/github
Content type: application/json
Secret: [Configurado automaticamente]
Events: Just the push event
```

## 🔄 Workflow Completo

### Fluxo de Desenvolvimento

```bash
# 1. Desenvolver no Replit
# Editar código, testar localmente

# 2. Commit e Push
git add .
git commit -m "feat: Nova funcionalidade X"
git push origin main

# 3. Trigger Automático
# GitHub → Webhook → Codemagic

# 4. Build Automático
# Codemagic → Flutter Build → APK

# 5. Notificação
# Email → Download → Teste
```

### Branches e Ambientes

```yaml
# Estratégia de branches
main:           # Produção
  - Build APK release
  - Testes automatizados
  - Deploy automático

develop:        # Desenvolvimento
  - Build APK debug
  - Testes básicos
  - Preview builds

feature/*:      # Features
  - Build on PR only
  - Testes unitários
  - Code review
```

## 📱 Configuração Específica Flutter

### pubspec.yaml Otimizado
```yaml
name: motouber
description: Sistema de controle financeiro para motoristas
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.2.3
  sqflite: ^2.3.3
  path: ^1.8.3
  intl: ^0.19.0
  fl_chart: ^0.68.0
  file_picker: ^8.0.0
  permission_handler: ^11.3.1
  path_provider: ^2.1.3
  share_plus: ^9.0.0
  pdf: ^3.10.8
  printing: ^5.12.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
```

### Android Configuration
```xml
<!-- android/app/build.gradle -->
android {
    compileSdkVersion 34
    buildToolsVersion "34.0.0"
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
        multiDexEnabled true
    }
    
    buildTypes {
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
            signingConfig signingConfigs.debug
        }
    }
}
```

## 🚨 Troubleshooting

### Problemas Comuns Replit → GitHub

#### 1. Permissões Git
```bash
# Erro: Permission denied
git config --global credential.helper store
git config --global user.name "Seu Nome"
git config --global user.email "seu@email.com"
```

#### 2. Arquivos Grandes
```bash
# Remover arquivos grandes do Git
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch build/' \
  --prune-empty --tag-name-filter cat -- --all
```

#### 3. Conflitos de Merge
```bash
# Resolver conflitos
git pull origin main
# Resolver conflitos manualmente
git add .
git commit -m "resolve: Conflitos resolvidos"
git push origin main
```

### Problemas GitHub → Codemagic

#### 1. Webhook Não Funciona
```bash
# Verificar:
1. GitHub App instalada
2. Repositório selecionado
3. Webhook ativo
4. codemagic.yaml válido
```

#### 2. Build Falha
```yaml
# Verificar logs:
- Flutter version compatibility
- Dependencies conflicts
- Android SDK version
- Build scripts errors
```

#### 3. Artifacts Não Gerados
```yaml
# Verificar codemagic.yaml:
artifacts:
  - build/app/outputs/**/*.apk
  - build/app/outputs/**/mapping.txt
  - build/app/outputs/**/bundle.aab
```

## 🎯 Otimizações

### Performance Build
```yaml
# Cacheamento agressivo
scripts:
  - name: Cache dependencies
    script: |
      flutter pub get
      flutter pub deps
      flutter precache
```

### Segurança
```yaml
# Variáveis de ambiente
environment:
  vars:
    APP_ENV: production
    API_URL: https://api.motouber.com
  encrypted:
    KEYSTORE_PASSWORD: $KEYSTORE_PASSWORD
    KEY_PASSWORD: $KEY_PASSWORD
```

### Monitoramento
```yaml
# Notificações múltiplas
publishing:
  email:
    recipients:
      - dev@motouber.com
      - mobile@motouber.com
  slack:
    channel: '#mobile-builds'
  webhooks:
    - name: Build Status
      url: https://api.motouber.com/build-status
```

## 📋 Checklist Final

### Pré-configuração
- [ ] Projeto Flutter funcionando no Replit
- [ ] Conta GitHub ativa
- [ ] Conta Codemagic criada
- [ ] Dependências atualizadas

### Configuração
- [ ] Replit conectado ao GitHub
- [ ] .gitignore configurado
- [ ] Repositório GitHub criado
- [ ] Codemagic GitHub App instalada
- [ ] Webhook configurado
- [ ] codemagic.yaml válido

### Validação
- [ ] Push do Replit para GitHub funciona
- [ ] Webhook GitHub → Codemagic funciona
- [ ] Build automático executa
- [ ] APK gerado com sucesso
- [ ] Notificações recebidas
- [ ] Pipeline completo funcionando

## 🎉 Resultado Final

```
✅ Desenvolver no Replit (Flutter IDE)
✅ Versionamento no GitHub (Git)
✅ Build automático no Codemagic (CI/CD)
✅ APK Android nativo (~25MB)
✅ Distribuição automática (Email/Slack)
✅ Pipeline completo funcionando
```

**Próximo passo**: Implementar este guia e fazer o primeiro build completo! 🚀

---

**Compatibilidade**: Testado com Flutter 3.24+, Dart 3.0+, Android SDK 34, Replit 2025, GitHub Actions, Codemagic macOS M2.