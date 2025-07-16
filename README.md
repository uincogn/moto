motouber/
├── lib/
│   ├── main.dart              # Ponto de entrada
│   ├── models/                # Modelos de dados
│   ├── services/              # Serviços (Database)
│   ├── screens/               # Telas do aplicativo
│   └── theme/                 # Tema personalizado
├── android/                   # Configurações Android
├── codemagic.yaml            # CI/CD Codemagic
└── build_apk.sh              # Script de build VPS
```

## 🚀 Como usar

### Pré-requisitos
- Flutter SDK 3.0+
- Android SDK (para APK)
- Dart SDK

### Instalação
```bash
# Clone o repositório
git clone https://github.com/SEU-USUARIO/motouber.git
cd motouber

# Instale as dependências
flutter pub get

# Execute o app
flutter run
```

### Build APK
```bash
# Build para produção
flutter build apk --release

# APK estará em: build/app/outputs/flutter-apk/app-release.apk
```

## 🎯 Deploy Automatizado

### Codemagic (Recomendado)
1. Conecte seu repositório ao [Codemagic](https://codemagic.io)
2. Use o arquivo `codemagic.yaml` já configurado
3. APK será gerado automaticamente

### VPS Build
```bash
# Configure o ambiente (Ubuntu 22.04)
chmod +x setup_vps.sh
./setup_vps.sh

# Build APK
chmod +x build_apk.sh
./build_apk.sh