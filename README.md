# 🏗️ KM$ - Monorepo Organizado

> ⚠️ **PROCESSO DE BUILD OBRIGATÓRIO**: Não é possível instalar Flutter SDK ou testar APKs diretamente no Replit. O fluxo de trabalho é sempre:
> 1. **Desenvolvimento**: Código editado no Replit  
> 2. **Push**: Alterações enviadas para GitHub  
> 3. **Build**: Compilação automática no Codemagic CI/CD  
> 4. **Teste**: Download do APK e instalação no dispositivo físico

## 📋 Visão Geral

Monorepo organizado do KM$, sistema de controle financeiro para motoristas de aplicativo, dividido em duas partes principais:

- **Frontend**: Aplicativo Flutter para Android
- **Backend**: API REST em Dart para funcionalidades Premium

## 📁 Estrutura do Projeto

```
km$/
├── frontend/              # Aplicativo Flutter (Android)
│   ├── lib/              # Código Dart do app
│   ├── android/          # Configurações Android
│   ├── assets/           # Recursos (imagens, ícones)
│   ├── pubspec.yaml      # Dependências Flutter
│   └── README.md         # Documentação Frontend
├── backend/              # API Dart para Premium
│   ├── lib/              # Código fonte da API
│   ├── bin/              # Executável servidor
│   ├── pubspec.yaml      # Dependências Dart
│   └── README.md         # Documentação Backend
├── docs/                 # Documentação técnica organizada
│   ├── architecture/     # Arquitetura e decisões técnicas
│   ├── setup/           # Guias de configuração
│   ├── decisions/       # Decisões tomadas e questões
│   ├── guides/          # Guias de desenvolvimento
│   ├── status/          # Status atual e pendências
│   └── deployment/      # Deploy e CI/CD
├── scripts/             # Scripts utilitários
├── README.md            # Este arquivo (visão geral)
├── replit.md            # Histórico técnico detalhado
└── LICENSE              # Licença MIT
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

## 🎯 **ETAPA 1 ATUAL: APRIMORAR BACKEND** (EM DESENVOLVIMENTO)

### 📊 Status Backend
- ✅ **API Funcionando**: Dart/Shelf rodando na porta 3000
- ✅ **Supabase Conectado**: PostgreSQL + JWT auth operacional
- ✅ **Rotas Básicas**: /health, /api/auth/register, /api/auth/login
- ⏳ **Em Desenvolvimento**: Funcionalidades premium e sincronização

### 🚀 Subetapas da Etapa 1

#### **1.1 Expandir Rotas da API** (EM PROGRESSO)
- ✅ Autenticação completa (register/login)
- ⏳ Rotas de dados (trabalho, gastos, manutenções)
- ⏳ Sistema de backup/sincronização
- ⏳ Rotas premium e assinatura

#### **1.2 Implementar Sincronização de Dados**
- ⏳ Upload de dados SQLite → Supabase
- ⏳ Download Supabase → SQLite
- ⏳ Conflict resolution (merge strategy)
- ⏳ Progress tracking

#### **1.3 Sistema Premium**
- ⏳ Verificação de assinatura
- ⏳ Limites de funcionalidades
- ⏳ Webhook de pagamento
- ⏳ Multi-device support

#### **1.4 Segurança e Performance**
- ⏳ Rate limiting aprimorado
- ⏳ Validação de dados
- ⏳ Logging e monitoring
- ⏳ Error handling robusto

#### **1.5 Deploy Preparation**
- ⏳ Configuração SSL/HTTPS
- ⏳ Environment variables produção
- ⏳ Health checks avançados
- ⏳ Backup automatizado

---

## 🔧 Tecnologias

### Frontend (Mobile App)
- **Flutter 3.24+** - Framework mobile
- **Dart** - Linguagem principal
- **SQLite** - Banco local
- **Material Design** - Interface

### Backend (API Premium)
- **Dart/Shelf** - Framework web nativo
- **Supabase** - PostgreSQL + Auth + Storage
- **JWT** - Autenticação segura
- **HTTPS** - Comunicação criptografada

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
1. ✅ **Backend**: Dart puro implementado (Shelf + PostgreSQL)
2. **Conflitos de Dados**: Sincronização cliente ↔ servidor
3. **Preços Premium**: Valor da assinatura mensal/anual
4. **Migração Dados**: Como transferir dados locais para nuvem
5. **Resolução de Conflitos**: Last-write-wins vs manual vs field-level

## 🔄 Separação Futura

Este monorepo será separado em dois repositórios independentes:
- `motouber-frontend` (App Flutter)
- `motouber-backend` (API Node.js)

Por enquanto, mantemos organizados em pastas separadas para facilitar desenvolvimento coordenado.

## 📚 Documentação

### Documentação Principal
- [Frontend README](frontend/README.md) - Documentação do app Flutter
- [Backend README](backend/README.md) - Documentação da API Dart
- [replit.md](replit.md) - Histórico técnico e decisões arquiteturais

### Documentação Técnica (docs/)
- [Arquitetura](docs/architecture/) - Decisões técnicas e opções de banco
- [Setup](docs/setup/) - Guias de configuração (Supabase, etc.)
- [Decisões](docs/decisions/) - Questões resolvidas e conflitos
- [Guias](docs/guides/) - Exemplos de integração e desenvolvimento
- [Status](docs/status/) - Situação atual e pendências

### Scripts e Utilidades
- [Scripts](scripts/) - Utilitários para teste e deployment

---

**Projeto**: Motouber - Controle Financeiro para Motoristas
**Licença**: MIT
**Desenvolvimento**: Replit + GitHub + Codemagic CI/CD