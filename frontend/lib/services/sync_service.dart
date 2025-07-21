import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'api_service.dart';
import 'database_service.dart';
import '../models/trabalho_model.dart';
import '../models/gasto_model.dart';
import '../models/manutencao_model.dart';

/// Serviço de sincronização entre SQLite local e backend
/// Gerencia upload/download de dados com estratégia last-write-wins
class SyncService extends ChangeNotifier {
  static final SyncService instance = SyncService._internal();
  SyncService._internal();

  final DatabaseService _db = DatabaseService.instance;
  
  bool _isSyncing = false;
  String _syncStatus = 'Aguardando';
  double _syncProgress = 0.0;
  DateTime? _lastSyncTime;

  // Getters
  bool get isSyncing => _isSyncing;
  String get syncStatus => _syncStatus;
  double get syncProgress => _syncProgress;
  DateTime? get lastSyncTime => _lastSyncTime;

  /// Sincronização completa (upload + download)
  Future<SyncResult> fullSync() async {
    if (_isSyncing) {
      return SyncResult(
        success: false,
        message: 'Sincronização já em andamento',
      );
    }

    _setSyncState(true, 'Iniciando sincronização...', 0.0);

    try {
      // 1. Verificar se está logado
      final isLoggedIn = await ApiService.isLoggedIn();
      if (!isLoggedIn) {
        throw Exception('Usuário não está logado');
      }

      // 2. Verificar conectividade
      _setSyncState(true, 'Verificando conexão...', 0.1);
      final isOnline = await ApiService.isOnline();
      if (!isOnline) {
        throw Exception('Sem conexão com o servidor');
      }

      // 3. Upload de dados locais
      _setSyncState(true, 'Enviando dados...', 0.2);
      await _uploadAllData();

      // 4. Download de dados do servidor
      _setSyncState(true, 'Baixando dados...', 0.6);
      await _downloadAllData();

      // 5. Finalizar
      _lastSyncTime = DateTime.now();
      _setSyncState(false, 'Sincronização concluída', 1.0);

      return SyncResult(
        success: true,
        message: 'Dados sincronizados com sucesso',
        syncTime: _lastSyncTime!,
      );

    } catch (e) {
      _setSyncState(false, 'Erro: $e', 0.0);
      return SyncResult(
        success: false,
        message: 'Erro na sincronização: $e',
      );
    }
  }

  /// Upload apenas (enviar dados locais para servidor)
  Future<SyncResult> uploadOnly() async {
    if (_isSyncing) {
      return SyncResult(success: false, message: 'Sincronização em andamento');
    }

    _setSyncState(true, 'Enviando dados...', 0.0);

    try {
      await _uploadAllData();
      _setSyncState(false, 'Dados enviados', 1.0);

      return SyncResult(
        success: true,
        message: 'Dados enviados com sucesso',
        syncTime: DateTime.now(),
      );
    } catch (e) {
      _setSyncState(false, 'Erro no envio: $e', 0.0);
      return SyncResult(success: false, message: 'Erro no envio: $e');
    }
  }

  /// Download apenas (baixar dados do servidor)
  Future<SyncResult> downloadOnly() async {
    if (_isSyncing) {
      return SyncResult(success: false, message: 'Sincronização em andamento');
    }

    _setSyncState(true, 'Baixando dados...', 0.0);

    try {
      await _downloadAllData();
      _setSyncState(false, 'Dados baixados', 1.0);

      return SyncResult(
        success: true,
        message: 'Dados baixados com sucesso',
        syncTime: DateTime.now(),
      );
    } catch (e) {
      _setSyncState(false, 'Erro no download: $e', 0.0);
      return SyncResult(success: false, message: 'Erro no download: $e');
    }
  }

  /// Upload de todos os dados locais
  Future<void> _uploadAllData() async {
    // Upload trabalhos
    _setSyncState(true, 'Enviando trabalhos...', 0.2);
    final trabalhos = await _db.getTrabalhos();
    final trabalhosJson = trabalhos.map((t) => t.toJson()).toList();
    
    final trabalhoResult = await ApiService.uploadTrabalhos(trabalhosJson);
    if (!trabalhoResult.success) {
      throw Exception('Erro ao enviar trabalhos: ${trabalhoResult.message}');
    }

    // Upload gastos
    _setSyncState(true, 'Enviando gastos...', 0.35);
    final gastos = await _db.getGastos();
    final gastosJson = gastos.map((g) => g.toJson()).toList();
    
    final gastosResult = await ApiService.uploadGastos(gastosJson);
    if (!gastosResult.success) {
      throw Exception('Erro ao enviar gastos: ${gastosResult.message}');
    }

    // Upload manutenções
    _setSyncState(true, 'Enviando manutenções...', 0.5);
    final manutencoes = await _db.getManutencoes();
    final manutencoesJson = manutencoes.map((m) => m.toJson()).toList();
    
    final manutencoesResult = await ApiService.uploadManutencoes(manutencoesJson);
    if (!manutencoesResult.success) {
      throw Exception('Erro ao enviar manutenções: ${manutencoesResult.message}');
    }
  }

  /// Download de todos os dados do servidor
  Future<void> _downloadAllData() async {
    // Download trabalhos
    _setSyncState(true, 'Baixando trabalhos...', 0.6);
    final trabalhoResult = await ApiService.downloadTrabalhos();
    if (trabalhoResult.success && trabalhoResult.data != null) {
      await _mergeTrabalhos(trabalhoResult.data!['trabalho'] as List);
    }

    // Download gastos  
    _setSyncState(true, 'Baixando gastos...', 0.75);
    final gastosResult = await ApiService.downloadGastos();
    if (gastosResult.success && gastosResult.data != null) {
      await _mergeGastos(gastosResult.data!['gastos'] as List);
    }

    // Download manutenções
    _setSyncState(true, 'Baixando manutenções...', 0.9);
    final manutencoesResult = await ApiService.downloadManutencoes();
    if (manutencoesResult.success && manutencoesResult.data != null) {
      await _mergeManutencoes(manutencoesResult.data!['manutencoes'] as List);
    }
  }

  /// Merge trabalhos com estratégia last-write-wins
  Future<void> _mergeTrabalhos(List trabalhosList) async {
    for (final trabalhoData in trabalhosList) {
      try {
        final trabalho = TrabalhoModel.fromJson(trabalhoData as Map<String, dynamic>);
        
        // Verificar se já existe localmente
        final existing = await _db.getTrabalhoById(trabalho.id);
        
        if (existing == null) {
          // Novo registro - inserir
          await _db.insertTrabalho(trabalho);
        } else {
          // Registro existe - comparar data de atualização (last-write-wins)
          if (trabalho.dataRegistro.isAfter(existing.dataRegistro)) {
            await _db.updateTrabalho(trabalho);
          }
        }
      } catch (e) {
        print('Erro ao fazer merge de trabalho: $e');
      }
    }
  }

  /// Merge gastos com estratégia last-write-wins
  Future<void> _mergeGastos(List gastosList) async {
    for (final gastoData in gastosList) {
      try {
        final gasto = GastoModel.fromJson(gastoData as Map<String, dynamic>);
        
        final existing = await _db.getGastoById(gasto.id);
        
        if (existing == null) {
          await _db.insertGasto(gasto);
        } else {
          if (gasto.dataRegistro.isAfter(existing.dataRegistro)) {
            await _db.updateGasto(gasto);
          }
        }
      } catch (e) {
        print('Erro ao fazer merge de gasto: $e');
      }
    }
  }

  /// Merge manutenções com estratégia last-write-wins
  Future<void> _mergeManutencoes(List manutencoesList) async {
    for (final manutencaoData in manutencoesList) {
      try {
        final manutencao = ManutencaoModel.fromJson(manutencaoData as Map<String, dynamic>);
        
        final existing = await _db.getManutencaoById(manutencao.id);
        
        if (existing == null) {
          await _db.insertManutencao(manutencao);
        } else {
          if (manutencao.dataRegistro.isAfter(existing.dataRegistro)) {
            await _db.updateManutencao(manutencao);
          }
        }
      } catch (e) {
        print('Erro ao fazer merge de manutenção: $e');
      }
    }
  }

  void _setSyncState(bool syncing, String status, double progress) {
    _isSyncing = syncing;
    _syncStatus = status;
    _syncProgress = progress;
    notifyListeners();
  }
}

class SyncResult {
  final bool success;
  final String message;
  final DateTime? syncTime;

  SyncResult({
    required this.success,
    required this.message,
    this.syncTime,
  });

  @override
  String toString() {
    return 'SyncResult(success: $success, message: $message, syncTime: $syncTime)';
  }
}