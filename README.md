# 📱 Motouber - Controle Financeiro para Motoristas

Sistema de controle financeiro para motoristas de aplicativo desenvolvido em Flutter/Dart com foco em usabilidade e funcionalidades completas.

## 🎯 Funcionalidades

- **Dashboard Principal**: Métricas do dia e mês
- **Registro de Trabalho**: Controle de ganhos e horas
- **Gastos**: Categorização e relatórios  
- **Manutenções**: Controle e alertas
- **Relatórios**: Gráficos e análises
- **Backup/Restore**: Segurança dos dados

## 🏗️ Estrutura do Projeto

```
motouber/
├── lib/
│   ├── main.dart              # Ponto de entrada
│   ├── models/                # Modelos de dados
│   ├── services/              # Serviços (Database)
│   ├── screens/               # Telas do aplicativo
│   └── theme/                 # Tema personalizado
├── android/                   # Configurações Android
├── assets/                    # Recursos (imagens, ícones)
├── codemagic.yaml            # CI/CD Codemagic
├── REPLIT_SETUP.md           # Configuração Replit
├── CODEMAGIC_GUIDE_2025.md   # Guia CI/CD 2025
└── REPLIT_GITHUB_INTEGRATION.md  # Integração completa
```

## 🚀 Desenvolvimento

### Replit (Recomendado)
1. **Abra o projeto no Replit**
2. **Execute para web**: `flutter run --web-port=5000 --web-hostname=0.0.0.0`
3. **Conecte ao GitHub**: Use o Git integrado
4. **Push automático**: Commit e push para trigger CI/CD

### Local
```bash
# Pré-requisitos
- Flutter SDK 3.24+
- Android SDK 34+
- Dart SDK 3.0+

# Instalação
git clone https://github.com/SEU-USUARIO/motouber.git
cd motouber
flutter pub get

# Executar
flutter run                    # Mobile
flutter run -d chrome         # Web
```

## 📦 Build APK

### Codemagic CI/CD (Recomendado)
1. **Conecte ao [Codemagic](https://codemagic.io)**
2. **Instale GitHub App** e autorize repositório
3. **Pipeline automático**: Push → Build → APK → Email
4. **Plano gratuito**: 500 minutos/mês

### Build Local
```bash
flutter build apk --release
# APK em: build/app/outputs/flutter-apk/app-release.apk
```

### VPS Build (Alternativa)
```bash
chmod +x setup_vps.sh && ./setup_vps.sh
chmod +x build_apk.sh && ./build_apk.sh