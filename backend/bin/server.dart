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
import '../lib/middleware/rate_limiter.dart';
import '../lib/middleware/error_handler.dart';
import '../lib/services/database_service.dart';

final _logger = Logger('MotouberServer');

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

  // Inicializar banco de dados
  try {
    await DatabaseService.initialize();
    _logger.info('Banco de dados conectado com sucesso');
  } catch (e) {
    _logger.severe('Erro ao conectar banco de dados: $e');
    exit(1);
  }

  // Configurar router principal
  final router = Router()
    // Health check
    ..get('/health', _healthHandler)
    
    // Rotas da API
    ..mount('/api/auth', AuthRoutes().router)
    ..mount('/api/premium', PremiumRoutes().router)
    ..mount('/api/backup', BackupRoutes().router)
    
    // 404 para rotas não encontradas
    ..all('/<ignored|.*>', _notFoundHandler);

  // Configurar middleware stack
  final handler = Pipeline()
    .addMiddleware(logRequests())
    .addMiddleware(corsHeaders())
    .addMiddleware(rateLimiterMiddleware())
    .addMiddleware(errorHandler())
    .addHandler(router);

  // Iniciar servidor
  final server = await serve(handler, host, port);
  
  _logger.info('🚀 Motouber Backend Dart rodando em ${server.address.host}:${server.port}');
  _logger.info('📡 Health check: http://${server.address.host}:${server.port}/health');
  
  // Graceful shutdown
  ProcessSignal.sigint.watch().listen((_) async {
    _logger.info('Finalizando servidor...');
    await server.close();
    await DatabaseService.close();
    exit(0);
  });
}

Response _healthHandler(Request request) {
  return Response.ok(
    '{"status": "OK", "message": "Motouber Backend Dart funcionando", "timestamp": "${DateTime.now().toIso8601String()}"}',
    headers: {'Content-Type': 'application/json'},
  );
}

Response _notFoundHandler(Request request) {
  return Response.notFound(
    '{"error": "Rota não encontrada", "path": "${request.url.path}"}',
    headers: {'Content-Type': 'application/json'},
  );
}