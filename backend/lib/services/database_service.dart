import 'package:postgres/postgres.dart';
import 'package:logging/logging.dart';

final _logger = Logger('DatabaseService');

class DatabaseService {
  static Connection? _connection;
  
  /// Inicializar conexão com PostgreSQL
  static Future<void> initialize() async {
    try {
      // TODO: Usar variáveis de ambiente reais
      final endpoint = Endpoint(
        host: 'localhost', // TODO: env['DB_HOST']
        port: 5432,        // TODO: env['DB_PORT']
        database: 'motouber', // TODO: env['DB_NAME']
        username: 'postgres', // TODO: env['DB_USER']
        password: 'password', // TODO: env['DB_PASS']
      );
      
      _connection = await Connection.open(
        endpoint,
        settings: ConnectionSettings(
          sslMode: SslMode.prefer,
          connectTimeout: Duration(seconds: 30),
          queryTimeout: Duration(seconds: 30),
        ),
      );
      
      _logger.info('Conexão PostgreSQL estabelecida');
      
      // Criar tabelas se não existirem
      await _createTables();
      
    } catch (e) {
      _logger.severe('Erro ao conectar PostgreSQL: $e');
      rethrow;
    }
  }
  
  /// Obter conexão ativa
  static Connection get connection {
    if (_connection == null) {
      throw StateError('Database não inicializado. Chame DatabaseService.initialize() primeiro');
    }
    return _connection!;
  }
  
  /// Fechar conexão
  static Future<void> close() async {
    await _connection?.close();
    _connection = null;
    _logger.info('Conexão PostgreSQL fechada');
  }
  
  /// Criar estrutura de tabelas
  static Future<void> _createTables() async {
    try {
      // Tabela de usuários
      await _connection!.execute('''
        CREATE TABLE IF NOT EXISTS users (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          email VARCHAR(255) UNIQUE NOT NULL,
          password_hash VARCHAR(255) NOT NULL,
          name VARCHAR(255) NOT NULL,
          is_premium BOOLEAN DEFAULT false,
          premium_expires_at TIMESTAMP WITH TIME ZONE,
          created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
          updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
        )
      ''');
      
      // Tabela de backups
      await _connection!.execute('''
        CREATE TABLE IF NOT EXISTS backups (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          user_id UUID REFERENCES users(id) ON DELETE CASCADE,
          data JSONB NOT NULL,
          size_bytes INTEGER,
          device_id VARCHAR(255),
          created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
        )
      ''');
      
      // Tabela de pagamentos
      await _connection!.execute('''
        CREATE TABLE IF NOT EXISTS payments (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          user_id UUID REFERENCES users(id) ON DELETE CASCADE,
          amount DECIMAL(10,2) NOT NULL,
          currency VARCHAR(3) DEFAULT 'BRL',
          plan VARCHAR(50) NOT NULL, -- 'monthly', 'annual'
          gateway VARCHAR(50) NOT NULL, -- 'pagseguro', 'stripe'
          gateway_transaction_id VARCHAR(255),
          status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'paid', 'failed', 'cancelled'
          created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
          paid_at TIMESTAMP WITH TIME ZONE
        )
      ''');
      
      // Tabela para resolução de conflitos de sincronização
      await _connection!.execute('''
        CREATE TABLE IF NOT EXISTS sync_conflicts (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          user_id UUID REFERENCES users(id) ON DELETE CASCADE,
          record_type VARCHAR(50) NOT NULL, -- 'trabalho', 'gasto', 'manutencao'
          record_id VARCHAR(255) NOT NULL,
          local_data JSONB NOT NULL,
          server_data JSONB NOT NULL,
          conflict_timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
          resolved BOOLEAN DEFAULT false,
          resolution_strategy VARCHAR(50), -- 'last_write_wins', 'manual', etc.
          resolved_at TIMESTAMP WITH TIME ZONE
        )
      ''');
      
      // Índices para performance
      await _connection!.execute('''
        CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
        CREATE INDEX IF NOT EXISTS idx_backups_user_id ON backups(user_id);
        CREATE INDEX IF NOT EXISTS idx_backups_created_at ON backups(created_at);
        CREATE INDEX IF NOT EXISTS idx_payments_user_id ON payments(user_id);
        CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(status);
        CREATE INDEX IF NOT EXISTS idx_sync_conflicts_user_id ON sync_conflicts(user_id);
        CREATE INDEX IF NOT EXISTS idx_sync_conflicts_resolved ON sync_conflicts(resolved);
      ''');
      
      _logger.info('Estrutura de tabelas criada/verificada');
      
    } catch (e) {
      _logger.severe('Erro ao criar tabelas: $e');
      rethrow;
    }
  }
  
  /// Executar query com log
  static Future<Result> query(String sql, [Map<String, dynamic>? parameters]) async {
    try {
      _logger.fine('Executando query: $sql');
      if (parameters != null) {
        return await connection.execute(Sql.named(sql), parameters: parameters);
      } else {
        return await connection.execute(sql);
      }
    } catch (e) {
      _logger.severe('Erro na query: $e\nSQL: $sql');
      rethrow;
    }
  }
}