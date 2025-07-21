import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:dotenv/dotenv.dart';
import 'package:logging/logging.dart';

import '../lib/routes/auth_routes.dart';
import '../lib/routes/premium_routes.dart';
import '../lib/routes/backup_routes.dart';
import '../lib/services/auth_service.dart';
import '../lib/services/supabase_service.dart';
import '../lib/middleware/rate_limiter.dart';
import '../lib/middleware/error_handler.dart';
import '../lib/middleware/https_enforcer.dart';
import '../lib/services/database_service.dart';

final _logger = Logger('KMDollarServer');

void main() async {
  // Configurar logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  // Carregar variáveis de ambiente
  final env = DotEnv(includePlatformEnvironment: true)..load();
  
  final port = int.parse(env['PORT'] ?? '3000');
  final host = env['HOST'] ?? '0.0.0.0';

  _logger.info('Iniciando servidor KM\$ Backend Dart...');
  
  // Inicializar serviços
  final supabaseUrl = env['SUPABASE_URL'];
  final supabaseAnonKey = env['SUPABASE_ANON_KEY'];
  final jwtSecret = env['JWT_SECRET'] ?? 'seu_jwt_secret_muito_seguro_km_dollar_backend_aqui';
  
  if (supabaseUrl == null || supabaseAnonKey == null) {
    _logger.severe('SUPABASE_URL e SUPABASE_ANON_KEY são obrigatórios no .env');
    exit(1);
  }
  
  final supabaseService = SupabaseService(supabaseUrl, supabaseAnonKey);
  final authService = AuthService(supabaseService, jwtSecret);
  
  // Inicializar tabelas do banco (executar apenas uma vez)
  try {
    await supabaseService.initializeTables();
    _logger.info('Banco de dados inicializado');
  } catch (e) {
    _logger.warning('Erro ao inicializar tabelas (pode já existirem): $e');
  }

  // Configurar router principal
  final router = Router()
    // Health check
    ..get('/health', _healthHandler)
    
    // Rotas da API
    ..mount('/api/auth/', AuthRoutes(authService).router)
    ..mount('/api/premium/', PremiumRoutes().router)
    ..mount('/api/backup/', BackupRoutes().router)
    
    // 404 para rotas não encontradas
    ..all('/<ignored|.*>', _notFoundHandler);

  // Configurar middleware stack
  final handler = Pipeline()
    .addMiddleware(logRequests())
    .addMiddleware(httpsEnforcerMiddleware()) // HTTPS primeiro
    .addMiddleware(corsHeaders())
    .addMiddleware(rateLimiterMiddleware())
    .addMiddleware(errorHandler())
    .addHandler(router);

  // Iniciar servidor
  final server = await serve(handler, host, port);
  
  _logger.info('🚀 KM\$ Backend Dart rodando em ${server.address.host}:${server.port}');
  _logger.info('📡 Health check: https://${server.address.host}:${server.port}/health');
  _logger.info('🔒 HTTPS OBRIGATÓRIO - Todas as comunicações devem usar SSL/TLS');
  
  // Graceful shutdown
  ProcessSignal.sigint.watch().listen((_) async {
    _logger.info('Finalizando servidor...');
    await server.close();
    exit(0);
  });
}

Response _healthHandler(Request request) {
  return Response.ok(
    '{"status": "OK", "message": "KM\$ Backend Dart funcionando", "timestamp": "${DateTime.now().toIso8601String()}", "https_required": true}',
    headers: {
      'Content-Type': 'application/json',
      'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
      'X-Content-Type-Options': 'nosniff',
      'X-Frame-Options': 'DENY',
      'X-XSS-Protection': '1; mode=block'
    },
  );
}

Response _notFoundHandler(Request request) {
  return Response.notFound(
    '{"error": "Rota não encontrada", "path": "${request.url.path}"}',
    headers: {'Content-Type': 'application/json'},
  );
}