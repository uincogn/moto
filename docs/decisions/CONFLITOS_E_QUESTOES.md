# 🚨 CONFLITOS DE DADOS E QUESTÕES PARA DEBATE

## 📋 Status: **QUESTÕES CRÍTICAS PARA RESOLUÇÃO**

Este documento centraliza todos os conflitos técnicos, questões de sincronização e decisões pendentes para o desenvolvimento do backend Dart e integração Premium.

---

## 🔄 **CONFLITOS DE SINCRONIZAÇÃO CLIENTE ↔ SERVIDOR**

### **1. CONFLITO: Registros Modificados em Ambos os Lados**

**Cenário**: Usuário modifica um registro no app (offline) e o mesmo registro é modificado no servidor

**Exemplo Prático**:
```dart
// Local (SQLite)
trabalho_id: 123
data: "2025-01-21"
ganhos: 150.00
updatedAt: "2025-01-21T10:30:00Z" // Modificado localmente

// Servidor (PostgreSQL) 
trabalho_id: 123
data: "2025-01-21" 
ganhos: 140.00
updatedAt: "2025-01-21T10:35:00Z" // Modificado no servidor (outro device)
```

**Questões para Debate**:
- **Qual valor prevalece?** ganhos: 150.00 ou 140.00?
- **Estratégia de resolução**:
  - `last_write_wins` (timestamp mais recente) ✅ Automático
  - `server_wins` (servidor sempre prevalece) ✅ Simples
  - `client_wins` (cliente sempre prevalece) ❌ Pode perder dados
  - `manual_resolution` (usuário decide) ✅ Mais seguro, mas complexo

### **2. CONFLITO: IDs Locais vs IDs Servidor**

**Problema**: SQLite usa IDs incrementais (1, 2, 3...), PostgreSQL usa UUIDs

**Cenário de Conflito**:
```dart
// App local cria registro offline
trabalho_id: 45 (incremental SQLite)

// Sincroniza com servidor 
servidor_uuid: "a1b2c3d4-e5f6-7890-abcd-ef1234567890"

// Como mapear? Criar tabela de correlação?
local_id | server_uuid | table_name | synced_at
45       | a1b2...     | trabalhos  | 2025-01-21T10:30:00Z
```

**Soluções Possíveis**:
1. **Tabela de Mapeamento**: Correlacionar IDs local ↔ servidor
2. **UUIDs Locais**: Gerar UUIDs no app desde o início 
3. **Dual-ID System**: Manter ambos os IDs em cada registro

### **3. CONFLITO: Registros Deletados vs Modificados**

**Cenário Complexo**:
```dart
1. Usuário deleta registro X no Device A (offline)
2. Usuário modifica registro X no Device B (online)
3. Sincronização: registro foi deletado ou modificado?
```

**Estratégias**:
- **Soft Delete**: Marcar como `deleted=true` em vez de remover fisicamente
- **Tombstones**: Manter registro de deleções com timestamp
- **Conflict Table**: Salvar conflitos para resolução manual

### **4. CONFLITO: Dados Offline Divergentes**

**Problema**: Dois devices offline modificam os mesmos dados

**Exemplo**:
```dart
// Device A (offline 2 dias)
trabalho_123: {ganhos: 150, updatedAt: "2025-01-19T08:00:00Z"}

// Device B (offline 1 dia)  
trabalho_123: {ganhos: 175, updatedAt: "2025-01-20T09:00:00Z"}

// Ambos sincronizam simultaneamente - qual vence?
```

---

## 🕐 **TIMESTAMP COMO SOLUÇÃO PARCIAL**

### **Vantagens do Timestamp**:
- ✅ **Ordem cronológica**: Determina qual modificação é mais recente
- ✅ **Resolução automática**: `last_write_wins` baseado em tempo
- ✅ **Auditoria**: Histórico de quando cada mudança ocorreu
- ✅ **Detecção de conflitos**: Compara timestamps local vs servidor

### **Limitações do Timestamp**:
- ❌ **Relógios dessincronizados**: Device com hora errada pode "vencer" incorretamente
- ❌ **Modificações simultâneas**: Timestamps idênticos (raro mas possível)
- ❌ **Contexto perdido**: Não considera qual modificação é mais "correta"
- ❌ **Fuso horário**: UTC vs local time pode gerar confusão

### **Soluções Complementares**:
1. **Vector Clocks**: Sistema de versionamento distribuído
2. **Conflict Score**: Peso baseado em tipo de modificação
3. **User Priority**: Dispositivo "master" tem preferência
4. **Field-Level Merge**: Mesclar campos não conflitantes

---

## 🎯 **QUESTÕES TÉCNICAS NÃO RESPONDIDAS**

### **Backend e Arquitetura**
1. **PostgreSQL no Replit**: Configuração gratuita vs pago?
2. **Migração de Schema**: Como atualizar estrutura sem perder dados?
3. **Backup Strategy**: PostgreSQL automated backup?
4. **Load Balancing**: Um servidor único é suficiente?
5. **Error Recovery**: Como recuperar de falhas de sincronização?

### **Pagamentos e Premium**
6. **Gateway Brasileiro**: PagSeguro vs Stripe vs ambos?
7. **Preço Regional**: R$ 9,90/mês é competitivo?
8. **Trial Period**: 7 dias gratuitos ou sem trial?
9. **Plano Anual**: Desconto de quantos %?
10. **Cancelamento**: Immediate vs end-of-period?

### **UX e Migração**
11. **Login Obrigatório**: Antes ou depois da compra Premium?
12. **Migração de Dados**: Upload automático ou manual?
13. **Conflitos na UI**: Como mostrar para o usuário resolver?
14. **Offline Premium**: Funcionalidades Premium funcionam offline?
15. **Multi-Device**: Quantos devices por conta Premium?

### **Segurança e Privacidade**
16. **Criptografia**: Dados são criptografados no servidor?
17. **LGPD Compliance**: Como implementar direito ao esquecimento?
18. **Auditoria**: Log de todas as modificações de dados?
19. **Rate Limiting**: Limites específicos por endpoint?
20. **Backup Encryption**: Backups são criptografados?

---

## 🔧 **CENÁRIOS DE CONFLITO ESPECÍFICOS**

### **Cenário A: Upgrade Premium com Dados Divergentes**
```
1. Usuário usa app gratuito em Device A (30 dias de dados)
2. Instala app em Device B, usa 7 dias
3. Compra Premium no Device B
4. Sincronização: como mesclar 30 dias (A) + 7 dias (B)?
```

**Questões**:
- Device A deve ser considerado "master"?
- Como detectar registros duplicados entre devices?
- Usuário deve aprovar merge antes de finalizar?

### **Cenário B: Downgrade Premium → Free**
```  
1. Usuário Premium cancela assinatura
2. Ainda tem 10 devices sincronizados
3. Após expiração, dados ficam no servidor?
4. Como lidar com dados que excedem limite Free?
```

**Questões**:
- Dados Premium são deletados imediatamente?
- Grace period de quantos dias após cancelamento?
- Como escolher quais dados manter (mais recentes? device principal?)

### **Cenário C: Conta Deletada com Dados Ativos**
```
1. Usuário deleta conta
2. Mas ainda tem app instalado em 3 devices
3. Apps continuam funcionando localmente
4. Usuário recria conta com mesmo email
```

**Questões**:
- Como associar dados antigos à nova conta?
- Dados locais devem ser "órfãos" permanentemente?
- Recriar conta = perder histórico de pagamentos?

---

## 📊 **ESTRATÉGIAS DE RESOLUÇÃO PROPOSTAS**

### **Estratégia 1: "Simple Last-Write-Wins" (Recomendada para MVP)**
```dart
if (serverTimestamp > localTimestamp) {
  useServerData();
} else {
  uploadLocalData(); 
}
```
**Prós**: Simples, rápida implementação
**Contras**: Pode perder dados importantes

### **Estratégia 2: "Field-Level Merge"**
```dart
mergedRecord = {
  // Campos não modificados: manter valor original
  id: original.id,
  
  // Campos modificados: usar timestamp mais recente
  ganhos: (server.ganhosUpdatedAt > local.ganhosUpdatedAt) 
    ? server.ganhos : local.ganhos,
    
  observacoes: (server.observacoesUpdatedAt > local.observacoesUpdatedAt)
    ? server.observacoes : local.observacoes
}
```
**Prós**: Preserva máximo de dados
**Contras**: Complexidade alta, requer timestamp por campo

### **Estratégia 3: "Conflict Queue + Manual Resolution"**
```dart
if (hasConflict(localData, serverData)) {
  saveToConflictQueue(localData, serverData);
  showConflictResolutionUI();
  waitForUserDecision();
}
```
**Prós**: Usuário tem controle total
**Contras**: UX complexa, pode acumular muitos conflitos

---

## ❓ **DECISÕES URGENTES NECESSÁRIAS**

### **Para Implementação Imediata**:
1. **Resolução de Conflitos**: Qual estratégia usar no MVP?
2. **ID Strategy**: UUIDs locais ou mapeamento dual-ID?
3. **Timestamp Format**: UTC ISO8601 em todos os registros?
4. **Soft Delete**: Implementar desde o início?

### **Para Validação com Usuários**:
5. **Preço Premium**: R$ 9,90/mês está adequado?
6. **Login UX**: Obrigatório antes de funcionalidades Premium?
7. **Conflict UI**: Como mostrar conflitos de forma clara?
8. **Multi-Device Limit**: Quantos devices por conta Premium?

### **Para Pesquisa/Teste**:
9. **PostgreSQL Replit**: Limitações do plano gratuito?
10. **PagSeguro Integration**: Documentação e sandbox disponível?
11. **Dart Shelf Performance**: Suporta carga de produção?
12. **Flutter HTTP**: Melhor package para APIs (dio vs http)?

---

## 📝 **PRÓXIMOS PASSOS SUGERIDOS**

### **Fase 1: Resolver Conflitos Críticos (Esta Semana)**
- [ ] Definir estratégia de resolução de conflitos (Simple Last-Write-Wins?)
- [ ] Decidir formato de IDs (UUIDs locais vs mapeamento)  
- [ ] Implementar timestamps UTC em todos os models Flutter
- [ ] Criar estrutura de soft delete no SQLite local

### **Fase 2: Implementar Backend Básico (2 semanas)**
- [ ] Configurar PostgreSQL no Replit
- [ ] Implementar rotas de autenticação (register/login)
- [ ] Sistema JWT funcional
- [ ] Primeira sincronização (upload simples)

### **Fase 3: Integração Premium (2-3 semanas)**
- [ ] Gateway de pagamento (PagSeguro)
- [ ] Controle de status Premium no app
- [ ] Migração dados Free → Premium
- [ ] UX de upgrade/downgrade

### **Fase 4: Resolver Conflitos Avançados (3-4 semanas)**
- [ ] Sistema robusto de merge
- [ ] UI para resolução manual de conflitos
- [ ] Multi-device sync completo
- [ ] Testes com cenários complexos

---

## 🚦 **STATUS DAS QUESTÕES**

| Questão | Status | Prioridade | Decisor |
|---------|--------|------------|---------|
| Estratégia de conflitos | ⏳ Pendente | 🔴 Crítica | Usuário |
| Preço Premium | ⏳ Pendente | 🔴 Crítica | Usuário | 
| Login obrigatório | ⏳ Pendente | 🟡 Alta | Usuário |
| PostgreSQL setup | ⏳ Pendente | 🟡 Alta | Técnico |
| PagSeguro integration | ⏳ Pendente | 🟡 Alta | Técnico |
| Multi-device limit | ⏳ Pendente | 🟢 Média | Produto |
| Conflict UI design | ⏳ Pendente | 🟢 Média | UX |
| LGPD compliance | ⏳ Pendente | 🟢 Baixa | Legal |

---

**Última atualização**: 2025-01-21
**Próxima revisão**: Após decisões do usuário sobre questões críticas