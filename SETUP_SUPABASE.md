# 🚀 SETUP SUPABASE - PASSO A PASSO

## 📋 **O QUE VOCÊ PRECISA FAZER AGORA**

### **1. CRIAR CONTA NO SUPABASE (5 minutos)**
1. Abra https://supabase.com
2. Clique em "Start your project"
3. Entre com GitHub ou crie conta
4. **É GRATUITO** até 500MB de dados

### **2. CRIAR PROJETO (3 minutos)**
1. Clique "New project"
2. Nome do projeto: `km-dollar`
3. Database password: **crie uma senha forte** (anote)
4. Região: **South America (São Paulo)** 
5. Plan: **Free** (já selecionado)
6. Clique "Create new project"

### **3. PEGAR CREDENCIAIS (2 minutos)**
Após o projeto ser criado:
1. Vá em **Settings** → **API**
2. Copie o **Project URL** (tipo: https://abc123.supabase.co)
3. Copie a **anon key** (começa com eyJhbGci...)

### **4. CONFIGURAR O BACKEND (1 minuto)**
Substitua no arquivo `backend/.env`:
```env
# Substituir com seus dados reais:
SUPABASE_URL=https://SEU-PROJETO.supabase.co
SUPABASE_ANON_KEY=SUA_ANON_KEY_AQUI
```

### **5. TESTAR CONEXÃO (2 minutos)**
```bash
cd backend
dart pub get
dart run bin/server.dart
```

Se aparecer: `"Banco de dados inicializado"` = **SUCESSO!** ✅

## 🔧 **COMANDOS DE TESTE**

### **1. Testar Health Check**
```bash
curl http://localhost:3000/health
```

### **2. Testar Registro de Usuário**
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "teste@teste.com",
    "password": "123456",
    "name": "Usuario Teste"
  }'
```

### **3. Testar Login**
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "teste@teste.com",
    "password": "123456"
  }'
```

## 🎯 **O QUE VAI ACONTECER**

### **✅ SUCESSO:**
- Registro: Retorna usuário + JWT token
- Login: Retorna usuário + JWT token válido
- Banco criado automaticamente com tabelas `users` e `sync_data`

### **❌ ERROS COMUNS:**

**"SUPABASE_URL é obrigatório":**
- Você esqueceu de configurar o .env

**"Failed to create user":**
- Problema com credenciais Supabase
- Verifique se URL e API key estão corretos

**"Email já cadastrado":**
- Usuário teste já existe - sucesso! ✅

## 📊 **CRIAR TABELAS NO SUPABASE**

**IMPORTANTE**: As tabelas precisam ser criadas manualmente no dashboard:

1. Vá em **SQL Editor** no dashboard Supabase
2. Cole e execute este SQL:
```sql
-- Criar tabela users
CREATE TABLE IF NOT EXISTS users (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  is_premium BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  premium_until TIMESTAMP,
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_premium ON users(is_premium);

-- Tabela para dados de sincronização  
CREATE TABLE IF NOT EXISTS sync_data (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  table_name TEXT NOT NULL,
  data JSONB NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_sync_user_table ON sync_data(user_id, table_name);

-- Habilitar Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE sync_data ENABLE ROW LEVEL SECURITY;

-- Políticas básicas  
CREATE POLICY "Users can view own data" ON users FOR SELECT USING (true);
CREATE POLICY "Users can insert own data" ON users FOR INSERT WITH CHECK (true);
CREATE POLICY "Sync data policy" ON sync_data FOR ALL USING (true);
```

3. Clique **RUN** 
4. Vá em **Table Editor** para ver as tabelas criadas

## 🧪 **SCRIPT DE TESTE AUTOMÁTICO**

Execute o script de testes:
```bash
./test_backend.sh
```

Ou teste manualmente:
```bash
# 1. Health check
curl http://localhost:3000/health

# 2. Registrar usuário  
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"teste@kmdollar.com","password":"123456","name":"Teste"}'

# 3. Fazer login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"teste@kmdollar.com","password":"123456"}'
```

## 🚀 **PRÓXIMOS PASSOS**

Assim que conseguir:
1. ✅ Registrar usuário  
2. ✅ Fazer login
3. ✅ Ver dados no Supabase
4. ✅ Token JWT funcional

**Podemos partir para:**
- Conectar Flutter ao backend
- Implementar sincronização
- Sistema Premium

## 🆘 **PROBLEMAS?**

**Cole aqui o erro exato** e te ajudo a resolver!

Exemplos do que colar:
- Log completo do `dart run bin/server.dart`
- Resposta do curl (mesmo que erro)
- Screenshot do dashboard Supabase

---

**Tempo total: ~15 minutos**  
**Custo: R$ 0,00 (free tier)**  
**Status: Pronto para conectar Flutter!**