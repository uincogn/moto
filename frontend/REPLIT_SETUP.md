# 🔧 Configuração Replit para Motouber

## 📋 Instruções de Configuração

### 1. Ambiente Replit
- **Linguagem**: Flutter/Dart
- **Módulos**: Flutter SDK incluído
- **Porta**: 5000 (para desenvolvimento web)
- **Hostname**: 0.0.0.0 (acessível externamente)

### 2. Comandos Principais

#### Desenvolvimento Web
```bash
flutter run --web-port=5000 --web-hostname=0.0.0.0
```

#### Build APK
```bash
flutter build apk --release
```

#### Testes
```bash
flutter test
```

#### Análise de Código
```bash
flutter analyze
```

### 3. Configuração Git (Replit → GitHub)

#### Conectar ao GitHub
1. Clique no ícone Git na barra lateral
2. Selecione "Connect to GitHub"
3. Autorize a conexão
4. Crie ou selecione repositório

#### Comandos Git
```bash
# Configurar usuário
git config --global user.name "Seu Nome"
git config --global user.email "seu@email.com"

# Adicionar e commit
git add .
git commit -m "feat: Descrição da mudança"

# Push para GitHub
git push origin main
```

### 4. Estrutura de Projeto

```
motouber/
├── lib/                    # Código Flutter
│   ├── main.dart          # Ponto de entrada
│   ├── models/            # Modelos de dados
│   ├── services/          # Serviços (Database)
│   ├── screens/           # Telas do app
│   └── theme/             # Tema personalizado
├── android/               # Configurações Android
├── assets/                # Recursos (imagens, ícones)
├── codemagic.yaml         # CI/CD Codemagic
├── pubspec.yaml           # Dependências
└── README.md              # Documentação
```

### 5. Dependências Atualizadas (2025)

```yaml
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
```

### 6. Configurações Android

#### Versões
- **compileSdkVersion**: 34
- **minSdkVersion**: 21
- **targetSdkVersion**: 34
- **buildToolsVersion**: "34.0.0"

#### Permissões
- `android.permission.INTERNET`
- `android.permission.WRITE_EXTERNAL_STORAGE`
- `android.permission.READ_EXTERNAL_STORAGE`

### 7. Workflow de Desenvolvimento

```
1. Desenvolver no Replit
   └── Testar com flutter run --web

2. Commit no Git
   └── git add . && git commit -m "..."

3. Push para GitHub
   └── git push origin main

4. Build automático no Codemagic
   └── Webhook → Build → APK → Email
```

### 8. Comandos Úteis

#### Limpar Cache
```bash
flutter clean
flutter pub get
```

#### Atualizar Dependências
```bash
flutter pub upgrade
```

#### Verificar Dependências
```bash
flutter pub deps
```

#### Analisar Código
```bash
flutter analyze
dart format .
```

### 9. Troubleshooting

#### Erro de Dependências
```bash
flutter clean
rm -rf .dart_tool
flutter pub get
```

#### Erro de Permissões Git
```bash
git config --global credential.helper store
```

#### Erro de Build
```bash
flutter doctor
flutter clean
flutter pub get
flutter build apk --release
```

### 10. Integração Codemagic

#### Arquivo de Configuração
- `codemagic.yaml` na raiz do projeto
- Triggers: push, pull_request
- Branches: main, develop
- Artifacts: APK, mapping, logs

#### Notificações
- Email configurado em `codemagic.yaml`
- Sucesso e falha notificados
- Link direto para download do APK

### 11. Próximos Passos

1. **Configurar Git**: Conectar Replit ao GitHub
2. **Testar localmente**: `flutter run --web`
3. **Fazer push**: Enviar código para GitHub
4. **Configurar Codemagic**: Conectar repositório
5. **Primeiro build**: Validar pipeline completo

---

## 📱 Resultado Final

- **Desenvolvimento**: Replit (Flutter Web)
- **Versionamento**: GitHub (Git)
- **Build**: Codemagic (CI/CD)
- **Produto**: APK Android (~25MB)
- **Distribuição**: Email automático

**Status**: Projeto configurado e pronto para pipeline completo! 🚀