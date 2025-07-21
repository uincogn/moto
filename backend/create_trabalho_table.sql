-- Criar tabela trabalho no Supabase
-- Execute este SQL no SQL Editor do dashboard Supabase

CREATE TABLE IF NOT EXISTS trabalho (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  data DATE NOT NULL,
  ganhos DECIMAL(10,2) NOT NULL,
  quilometragem_inicial INTEGER NOT NULL,
  quilometragem_final INTEGER NOT NULL,
  horas_trabalhadas DECIMAL(4,2) NOT NULL,
  observacoes TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Criar índices para performance
CREATE INDEX IF NOT EXISTS idx_trabalho_user_id ON trabalho(user_id);
CREATE INDEX IF NOT EXISTS idx_trabalho_data ON trabalho(data);
CREATE INDEX IF NOT EXISTS idx_trabalho_user_data ON trabalho(user_id, data);

-- Verificar se foi criada
SELECT tablename FROM pg_tables WHERE tablename = 'trabalho' AND schemaname = 'public';