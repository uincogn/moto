import 'dart:convert';
import 'package:motouber/services/api_service.dart';
import 'package:motouber/services/database_service.dart';
import 'package:motouber/services/premium_service.dart';
import 'package:motouber/models/trabalho_model.dart';
import 'package:motouber/models/gasto_model.dart';
import 'package:motouber/models/manutencao_model.dart';

class SyncService {
  static const String _lastSyncKey = 'last_sync_timestamp';
  
  // Sincronização completa
  static Future<SyncResult> syncData({
    bool forceFullSync = false,
  }) async {
    try {
      // Verificar se usuário é Premium
      final premiumStatus = await PremiumService.checkPremiumStatus();
      if (!premiumStatus.isPremium) {
        return SyncResult(
          success: false,
          message: 'Sincronização disponível apenas para usuários Premium',
          syncType: SyncType.blocked,
        );
      }

      // Verificar conectividade
      if (!premiumStatus.isOnline) {
        return SyncResult(
          success: false,
          message: 'Sem conexão com a internet',
          syncType: SyncType.offline,
        );
      }

      // Verificar se usuário está logado
      if (!await ApiService.isLoggedIn()) {
        return SyncResult(
          success: false,
          message: 'Usuário não está logado',
          syncType: SyncType.authRequired,
        );
      }

      SyncResult result;
      if (forceFullSync) {
        result = await _performFullSync();
      } else {
        result = await _performIncrementalSync();
      }

      if (result.success) {
        await PremiumService.markLastSync();
      }

      return result;
    } catch (e) {
      return SyncResult(
        success: false,
        message: 'Erro durante sincronização: $e',
        syncType: SyncType.error,
      );
    }
  }

  // Sincronização completa (upload + download)
  static Future<SyncResult> _performFullSync() async {
    try {
      final db = DatabaseService.instance;
      
      // 1. Fazer backup dos dados locais
      final localData = await _exportLocalData();
      
      // 2. Fazer upload dos dados locais
      final uploadResult = await ApiService.uploadBackup(localData);
      if (!uploadResult.success) {
        return SyncResult(
          success: false,
          message: 'Falha no upload: ${uploadResult.message}',
          syncType: SyncType.uploadFailed,
        );
      }

      // 3. Baixar dados do servidor
      final downloadResult = await ApiService.downloadBackup();
      if (!downloadResult.success) {
        return SyncResult(
          success: false,
          message: 'Falha no download: ${downloadResult.message}',
          syncType: SyncType.downloadFailed,
        );
      }

      // 4. Mesclar dados (resolver conflitos)
      if (downloadResult.data != null && downloadResult.data!['data'] != null) {
        final serverData = downloadResult.data!['data'] as Map<String, dynamic>;
        final mergeResult = await _mergeData(localData['data'], serverData);
        
        return SyncResult(
          success: true,
          message: 'Sincronização completa realizada com sucesso',
          syncType: SyncType.fullSync,
          conflictsResolved: mergeResult.conflictsCount,
          recordsSynced: mergeResult.recordsProcessed,
        );
      }

      return SyncResult(
        success: true,
        message: 'Upload realizado com sucesso',
        syncType: SyncType.uploadOnly,
      );
    } catch (e) {
      return SyncResult(
        success: false,
        message: 'Erro na sincronização completa: $e',
        syncType: SyncType.error,
      );
    }
  }

  // Sincronização incremental (apenas mudanças)
  static Future<SyncResult> _performIncrementalSync() async {
    // Por enquanto, usar sincronização completa
    // TODO: Implementar lógica incremental baseada em timestamps
    return await _performFullSync();
  }

  // Exportar dados locais
  static Future<Map<String, dynamic>> _exportLocalData() async {
    final db = DatabaseService.instance;
    
    final trabalhos = await db.getAllTrabalhos();
    final gastos = await db.getAllGastos();
    final manutencoes = await db.getAllManutencoes();

    return {
      'version': '2.0',
      'export_date': DateTime.now().toIso8601String(),
      'data': {
        'trabalhos': trabalhos.map((t) => t.toMap()).toList(),
        'gastos': gastos.map((g) => g.toMap()).toList(),
        'manutencoes': manutencoes.map((m) => m.toMap()).toList(),
      },
      'stats': {
        'total_trabalhos': trabalhos.length,
        'total_gastos': gastos.length,
        'total_manutencoes': manutencoes.length,
      }
    };
  }

  // Mesclar dados locais e do servidor
  static Future<MergeResult> _mergeData(
    Map<String, dynamic> localData,
    Map<String, dynamic> serverData,
  ) async {
    int conflictsCount = 0;
    int recordsProcessed = 0;

    try {
      final db = DatabaseService.instance;

      // Mesclar trabalhos
      if (serverData['trabalhos'] != null) {
        final serverTrabalhos = (serverData['trabalhos'] as List)
            .map((data) => TrabalhoModel.fromMap(data))
            .toList();
        
        for (final trabalho in serverTrabalhos) {
          final existing = await db.getTrabalhoByDate(trabalho.data);
          if (existing != null) {
            // Conflito detectado - usar "last write wins"
            if (trabalho.dataRegistro.isAfter(existing.dataRegistro)) {
              await db.updateTrabalho(trabalho);
              conflictsCount++;
            }
          } else {
            await db.insertTrabalho(trabalho);
          }
          recordsProcessed++;
        }
      }

      // Mesclar gastos
      if (serverData['gastos'] != null) {
        final serverGastos = (serverData['gastos'] as List)
            .map((data) => GastoModel.fromMap(data))
            .toList();
        
        for (final gasto in serverGastos) {
          // Para gastos, inserir sempre (podem haver múltiplos por dia)
          await db.insertGasto(gasto);
          recordsProcessed++;
        }
      }

      // Mesclar manutenções
      if (serverData['manutencoes'] != null) {
        final serverManutencoes = (serverData['manutencoes'] as List)
            .map((data) => ManutencaoModel.fromMap(data))
            .toList();
        
        for (final manutencao in serverManutencoes) {
          // Para manutenções, inserir sempre
          await db.insertManutencao(manutencao);
          recordsProcessed++;
        }
      }

      return MergeResult(
        conflictsCount: conflictsCount,
        recordsProcessed: recordsProcessed,
      );
    } catch (e) {
      throw Exception('Erro ao mesclar dados: $e');
    }
  }

  // Verificar se precisa sincronizar
  static Future<bool> needsSync() async {
    final lastSync = await PremiumService.getLastSync();
    if (lastSync == null) return true;

    final now = DateTime.now();
    final difference = now.difference(lastSync);

    // Sincronizar se passou mais de 1 hora
    return difference.inHours >= 1;
  }

  // Status da sincronização
  static Future<Map<String, dynamic>> getSyncStatus() async {
    final isPremium = await PremiumService.isPremium();
    final lastSync = await PremiumService.getLastSync();
    final needsSync = await SyncService.needsSync();
    final isOnline = await ApiService.isOnline();
    
    return {
      'is_premium': isPremium,
      'can_sync': isPremium && isOnline,
      'last_sync': lastSync?.toIso8601String(),
      'needs_sync': needsSync,
      'is_online': isOnline,
      'sync_available': isPremium,
    };
  }
}

class SyncResult {
  final bool success;
  final String message;
  final SyncType syncType;
  final int? conflictsResolved;
  final int? recordsSynced;

  SyncResult({
    required this.success,
    required this.message,
    required this.syncType,
    this.conflictsResolved,
    this.recordsSynced,
  });

  @override
  String toString() {
    return 'SyncResult(success: $success, message: $message, type: $syncType)';
  }
}

class MergeResult {
  final int conflictsCount;
  final int recordsProcessed;

  MergeResult({
    required this.conflictsCount,
    required this.recordsProcessed,
  });
}

enum SyncType {
  blocked,
  offline,
  authRequired,
  error,
  fullSync,
  incrementalSync,
  uploadOnly,
  downloadOnly,
  uploadFailed,
  downloadFailed,
}