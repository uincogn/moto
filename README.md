# 🏗️ Motouber - Monorepo Organizado

## 📋 Visão Geral

Monorepo organizado do Motouber, sistema de controle financeiro para motoristas de aplicativo, dividido em duas partes principais:

- **Frontend**: Aplicativo Flutter para Android
- **Backend**: API REST em Node.js para funcionalidades Premium

## 📁 Estrutura do Projeto

```
motouber/
├── frontend/              # Aplicativo Flutter (Android)
│   ├── lib/              # Código Dart do app
│   ├── android/          # Configurações Android
│   ├── assets/           # Recursos (imagens, ícones)
│   ├── pubspec.yaml      # Dependências Flutter
│   └── README.md         # Documentação Frontend
├── backend/              # API Node.js para Premium
│   ├── src/              # Código fonte da API
│   ├── package.json      # Dependências Node.js
│   ├── server.js         # Servidor principal
│   └── README.md         # Documentação Backend
├── README.md             # Este arquivo (visão geral)
└── replit.md             # Documentação técnica detalhada
```

## 🎯 Modelo de Negócio

### App Gratuito na Play Store
- **Download gratuito** na Google Play Store
- **Funcionalidades básicas** incluídas sem custo
- **Funcionalidades Premium** exigem assinatura

### Sistema Freemium
- **Gratuito**: Dashboard, registro básico, gastos locais
- **Premium**: Backup nuvem, multi-device, relatórios avançados, PDF export

### Fluxo de Upgrade
1. Usuário baixa app gratuito
2. Usa funcionalidades básicas
3. Funcionalidades Premium mostram aviso de upgrade
4. Compra assinatura no app
5. Dados locais são enviados para nuvem
6. Perfil Premium ativado

## 🔧 Tecnologias

### Frontend (Mobile App)
- **Flutter 3.24+** - Framework mobile
- **Dart** - Linguagem principal
- **SQLite** - Banco local
- **Material Design** - Interface

### Backend (API Premium)
- **Node.js 18+** - Runtime JavaScript
- **Express.js** - Framework web
- **PostgreSQL** - Banco de dados
- **JWT** - Autenticação

## 🚀 Desenvolvimento

### Frontend (App Flutter)
```bash
cd frontend
flutter pub get
flutter run --web-port=5000 --web-hostname=0.0.0.0
```

### Backend (API Node.js)
```bash
cd backend
npm install
npm run dev
```

### Build APK
```bash
cd frontend
flutter build apk --release
```

## 🌐 Deploy

### Frontend
- **Codemagic**: Build automático APK
- **Play Store**: Distribuição do app

### Backend
- **Replit**: Hosting gratuito da API
- **Heroku/Railway**: Alternativas de hosting

## 📝 Próximos Passos

### Implementação Prioritária
1. **Backend API**: Autenticação, Premium, Backup
2. **Integração Flutter**: Consumo das APIs
3. **Gateway Pagamento**: PagSeguro/Stripe
4. **Deploy Produção**: API em hosting definitivo

### Questões para Debate
1. **Conflitos Técnicos**: Dart puro vs Node.js backend
2. **Preços Premium**: Valor da assinatura mensal/anual
3. **Migração Dados**: Como transferir dados locais para nuvem
4. **UX Premium**: Experiência de upgrade no app

## 🔄 Separação Futura

Este monorepo será separado em dois repositórios independentes:
- `motouber-frontend` (App Flutter)
- `motouber-backend` (API Node.js)

Por enquanto, mantemos organizados em pastas separadas para facilitar desenvolvimento coordenado.

## 📚 Documentação

- [Frontend README](frontend/README.md) - Documentação do app Flutter
- [Backend README](backend/README.md) - Documentação da API Node.js
- [replit.md](replit.md) - Histórico técnico e decisões arquiteturais

---

**Projeto**: Motouber - Controle Financeiro para Motoristas
**Licença**: MIT
**Desenvolvimento**: Replit + GitHub + Codemagic CI/CD