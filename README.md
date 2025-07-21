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
```

## 📋 DISCUSSÃO: BACKEND + PREMIUM + BACKUP EM NUVEM

### 🎯 **Estratégia de Implementação Proposta**

#### **Divisão em 2 Projetos Separados**
```
Projeto 1: motouber-backend
- Sistema de autenticação
- Gerenciamento Premium
- API de backup em nuvem
- Controle de pagamentos

Projeto 2: motouber-premium (evolução do atual)
- Integração com backend
- Funcionalidades Premium
- Sistema de login/cadastro
- Backup automático
```

### 🖥️ **Como o Backend Conversa com o App**

#### **Comunicação via APIs REST**
- **App** faz requisições HTTP para o **Backend**
- **Backend** responde com dados JSON
- **Exemplo**: `GET /api/user/premium-status` → `{"isPremium": true}`

#### **Fluxo de Comunicação**
```
1. App abre → Verifica se usuário está logado
2. Se logado → Consulta status Premium via API
3. Backend verifica no banco → Responde
4. App libera/bloqueia funcionalidades
5. Backup automático via API calls
```

### ⚙️ **Tecnologias para Backend**

#### **Opção 1: Node.js + Express (Recomendada)**
```
- Replit nativo
- PostgreSQL integrado
- JWT para autenticação
- Deploy automático
```

#### **Opção 2: Python + FastAPI**
```
- Familiar para muitos devs
- SQLite ou PostgreSQL
- Rápido desenvolvimento
```

#### **Opção 3: Dart Backend**
```
- Mesma linguagem do Flutter
- Shelf framework
- Menor curva de aprendizado
```

### 🌐 **Firebase como Alternativa**

#### **Vantagens Firebase**
- **Autenticação**: Google, email, phone
- **Firestore**: Banco NoSQL automático
- **Storage**: Upload de arquivos
- **Hosting**: Deploy gratuito
- **SDK Flutter**: Integração nativa

#### **Desvantagens Firebase**
- Vendor lock-in (dependência Google)
- Custos podem escalar rapidamente
- Menos controle sobre dados
- Limitações query complexas

### 📊 **Sistema de Backup em Nuvem**

#### **Funcionamento**
```
1. App detecta mudanças nos dados
2. Compacta dados em JSON
3. Faz POST /api/backup/upload
4. Backend salva no PostgreSQL
5. Retorna confirmação para o app
```

#### **Sincronização Multi-device**
```
1. Usuário faz login em novo device
2. App consulta GET /api/backup/latest
3. Backend retorna último backup
4. Backend retorna último backup
5. App restaura dados localmente
5. Merge inteligente de dados
```

### 💳 **Sistema de Pagamentos Premium**

#### **Fluxo de Pagamento**
```
1. Usuário clica "Upgrade Premium"
2. App abre checkout (PagSeguro/Stripe)
3. Usuário paga
4. Gateway envia webhook para backend
5. Backend atualiza status: isPremium = true
6. App recebe confirmação via API
7. Funcionalidades Premium desbloqueadas
```

#### **Controle de Acesso**
```
Função no app:
bool canAccessPremium() {
  return user.isPremium && user.subscriptionActive;
}

Se false → Mostra tela de upgrade
Se true → Libera funcionalidade
```

### 🏗️ **Etapas de Implementação**

#### **FASE 1: Fundação Backend (2-3 semanas)**
```
✅ Criar projeto backend (Node.js/Replit)
✅ Configurar PostgreSQL
✅ Criar API de autenticação (/register, /login)
✅ Sistema JWT para tokens
✅ API básica de backup (/upload, /download)
✅ Deploy no Replit
```

#### **FASE 2: Premium Integration (2 semanas)**
```
✅ Integração gateway pagamento
✅ Webhook confirmação de pagamento
✅ API controle Premium (/upgrade, /status)
✅ Sistema de assinaturas
```

#### **FASE 3: App Evolution (3 semanas)**
```
✅ Telas login/cadastro no Flutter
✅ Consumo APIs backend
✅ Sistema de cache + sincronização
✅ Área Premium com bloqueios
✅ Backup automático implementado
```

#### **FASE 4: Premium Features (4 semanas)**
```
✅ Relatórios PDF avançados
✅ Dashboard analytics
✅ Alertas inteligentes
✅ Multi-device sync
✅ Funcionalidades exclusivas Premium
```

### ❓ **Questões em Debate**

#### **Técnicas**
- **Backend em que linguagem?** Node.js vs Python vs Dart
- **Banco de dados?** PostgreSQL vs SQLite inicial
- **Authentication?** JWT vs Firebase Auth vs OAuth
- **Payment gateway?** PagSeguro vs Stripe vs ambos
- **Hosting?** Replit vs Railway vs Heroku

#### **Produto**
- **Preço Premium?** R$ 9,90/mês vs R$ 29,90 único
- **Plano Free generoso ou limitado?**
- **Recursos Free vs Premium?** Definir exatamente
- **Backup Free tem limite?** Ex: últimos 30 dias
- **Trial gratuito?** 7 dias Premium grátis

#### **Experiência do Usuário**
- **Login obrigatório ou opcional?** 
- **Como migrar usuários atuais?** Dados locais → nuvem
- **Onboarding novos usuários?** Tutorial Premium
- **Cancelamento fácil?** Auto-renovação vs compra única
- **Offline first?** App funciona sem internet

### 🔄 **Plano Incremental MVP**

#### **Abordagem Recomendada pelo Amigo**
```
Usar IA como "sócio que não dorme" para acelerar desenvolvimento

FASE 1 - Fundação Backend:
[ ] Criar projeto backend (Dart + Shelf)
[ ] Rota /register (cadastro)
[ ] Rota /login (login → JWT)
[ ] Rota /upgrade (Premium após pagamento)
[ ] Rota /backup/upload
[ ] Rota /backup/download
[ ] Middleware autenticação JWT
[ ] Hospedar no Railway (gratuito início)

FASE 2 - Integração App:
[ ] Tela login/cadastro
[ ] Detectar se usuário é Premium
[ ] Bloquear funcionalidades Premium
[ ] Liberar backup se Premium
[ ] Sincronização local + nuvem
[ ] Logout e reconexão

FASE 3 - Pagamento Premium:
[ ] Integração PagSeguro/Stripe
[ ] Checkout dentro do app
[ ] Callback /upgrade no backend
[ ] Atualizar perfil Premium

FASE 4 - Refino e Expansão:
[ ] Gerenciamento backups
[ ] Multi-device sync
[ ] Relatórios Premium exclusivos
[ ] Alertas e notificações Premium
[ ] Renovação automática
```

### 🎯 **Decisões Pendentes**

#### **Arquitetura**
- **2 repositórios separados** ou **monorepo**?
- **Backend primeiro** ou **desenvolvimento paralelo**?
- **MVP mínimo** ou **sistema completo** desde início?

#### **Monetização**
- **Freemium model**: Básico grátis + Premium pago
- **Preço justo**: R$ 9,90/mês ou R$ 49,90/ano
- **Recursos Free**: Backup 30 dias, relatórios básicos
- **Recursos Premium**: Backup ilimitado, relatórios avançados, multi-device, PDF export

#### **Infraestrutura**
- **Replit para backend**: Fácil, integrado, barato
- **PostgreSQL**: Banco robusto para produção
- **Codemagic CI/CD**: Build automático app + backend
- **Custos iniciais**: ~R$ 0-50/mês (planos gratuitos)

### 🏗️ **BACKEND NO MESMO REPOSITÓRIO**

#### **Estratégia Decidida: Monorepo**
```
motouber/
├── lib/                    # Flutter App (atual)
├── backend/               # Backend API (novo)
│   ├── src/
│   │   ├── routes/        # Rotas da API
│   │   ├── models/        # Modelos de dados
│   │   ├── services/      # Lógica de negócio
│   │   └── middleware/    # Autenticação, CORS
│   ├── package.json       # Dependências Node.js
│   └── server.js          # Servidor principal
├── android/               # Config Android
└── README.md             # Documentação completa
```

#### **Vantagens do Monorepo**
- **Desenvolvimento unificado**: Tudo em um lugar
- **Builds separados**: APK independente do backend
- **Deploy independente**: App e API podem ter deploys diferentes
- **Migração futura**: Fácil separar depois se necessário
- **Sincronização**: Mudanças coordenadas entre app e API

#### **Estrutura de Deploy**
```
Desenvolvimento:
- Replit: App Flutter + Backend Node.js
- Dois comandos separados para testar

Produção:
- APK: Codemagic (mesmo processo atual)
- Backend: Replit Deployment (URL fixa para API)
- Comunicação: App → https://motouber-api.replit.app
```

#### **Comandos Separados**
```bash
# Executar Flutter (atual)
flutter run --web-port=5000 --web-hostname=0.0.0.0

# Executar Backend (novo)
cd backend && npm start

# Build APK (atual - sem backend)
flutter build apk --release
```

#### **Próxima Implementação**

**FASE 1: Criar Backend (Node.js)**
```
backend/
├── src/
│   ├── routes/
│   │   ├── auth.js          # /register, /login
│   │   ├── premium.js       # /upgrade, /status  
│   │   └── backup.js        # /upload, /download
│   ├── middleware/
│   │   └── auth.js          # JWT validation
│   ├── models/
│   │   ├── User.js          # Schema usuário
│   │   └── Backup.js        # Schema backup
│   └── services/
│       ├── database.js      # PostgreSQL connection
│       └── payment.js       # PagSeguro integration
├── package.json
└── server.js                # Express app
```

**FASE 2: Integrar no App**
```
lib/services/
├── api_service.dart         # HTTP calls para backend
├── auth_service.dart        # Login/cadastro
└── premium_service.dart     # Controle Premium
```

**FASE 3: Deploy Separado**
```
- APK: Mesmo processo Codemagic atual
- Backend: Replit Autoscale Deployment
- Comunicação: App aponta para URL do backend
```

### 📝 **Próximas Decisões Necessárias**

1. **Escolher stack backend** (Node.js + Express recomendado)
2. **Definir preços Premium** (sugestão: R$ 9,90/mês)
3. **Mapear recursos Free vs Premium**
4. **Implementar backend na pasta dedicada**
5. **Manter builds separados** (APK independente)

---

## 🚀 Próximos Passos

### Para Implementar Após Decisões
- [ ] Sistema Premium completo
- [ ] Backend API completa  
- [ ] Backup automático em nuvem
- [ ] Sincronização multi-device
- [ ] Gateway de pagamentos
- [ ] Dashboard analytics Premium