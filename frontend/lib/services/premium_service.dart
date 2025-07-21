import 'package:shared_preferences/shared_preferences.dart';
import 'package:motouber/services/api_service.dart';

class PremiumService {
  static const String _premiumKey = 'is_premium';
  static const String _subscriptionKey = 'subscription_data';
  static const String _lastSyncKey = 'last_sync';

  // Status Premium Local (para modo offline)
  static Future<bool> isPremium() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_premiumKey) ?? false;
  }

  static Future<void> setPremiumStatus(bool isPremium) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, isPremium);
  }

  // Verificar status Premium no servidor
  static Future<PremiumStatus> checkPremiumStatus() async {
    try {
      // Verificar se está online
      final isOnline = await ApiService.isOnline();
      if (!isOnline) {
        // Modo offline - usar status local
        final localStatus = await isPremium();
        return PremiumStatus(
          isPremium: localStatus,
          isOnline: false,
          message: 'Modo offline - usando status local',
        );
      }

      // Verificar no servidor
      final response = await ApiService.checkPremiumStatus();
      
      if (response.success && response.data != null) {
        final isPremiumServer = response.data!['is_premium'] as bool? ?? false;
        
        // Atualizar status local
        await setPremiumStatus(isPremiumServer);
        
        // Salvar dados da assinatura se houver
        if (response.data!['subscription'] != null) {
          await _saveSubscriptionData(response.data!['subscription']);
        }
        
        return PremiumStatus(
          isPremium: isPremiumServer,
          isOnline: true,
          message: response.message,
          subscriptionData: response.data!['subscription'],
        );
      } else {
        // Falha no servidor - usar status local
        final localStatus = await isPremium();
        return PremiumStatus(
          isPremium: localStatus,
          isOnline: false,
          message: response.message,
        );
      }
    } catch (e) {
      // Erro - usar status local
      final localStatus = await isPremium();
      return PremiumStatus(
        isPremium: localStatus,
        isOnline: false,
        message: 'Erro ao verificar status: $e',
      );
    }
  }

  // Assinar Premium
  static Future<SubscriptionResult> subscribePremium() async {
    try {
      final response = await ApiService.createPremiumSubscription();
      
      if (response.success) {
        // Atualizar status local para Premium
        await setPremiumStatus(true);
        
        // Salvar dados da assinatura
        if (response.data!['subscription'] != null) {
          await _saveSubscriptionData(response.data!['subscription']);
        }
        
        return SubscriptionResult(
          success: true,
          message: response.message,
          paymentUrl: response.data?['payment_url'],
        );
      } else {
        return SubscriptionResult(
          success: false,
          message: response.message,
        );
      }
    } catch (e) {
      return SubscriptionResult(
        success: false,
        message: 'Erro ao processar assinatura: $e',
      );
    }
  }

  // Cancelar Premium
  static Future<SubscriptionResult> cancelPremium() async {
    try {
      final response = await ApiService.cancelPremiumSubscription();
      
      if (response.success) {
        // Atualizar status local
        await setPremiumStatus(false);
        await _clearSubscriptionData();
        
        return SubscriptionResult(
          success: true,
          message: response.message,
        );
      } else {
        return SubscriptionResult(
          success: false,
          message: response.message,
        );
      }
    } catch (e) {
      return SubscriptionResult(
        success: false,
        message: 'Erro ao cancelar assinatura: $e',
      );
    }
  }

  // Recursos Premium
  static Future<bool> canUseFeature(PremiumFeature feature) async {
    final isPremiumUser = await isPremium();
    
    switch (feature) {
      case PremiumFeature.cloudSync:
      case PremiumFeature.multiDevice:
      case PremiumFeature.advancedReports:
      case PremiumFeature.pdfExport:
      case PremiumFeature.smartAlerts:
      case PremiumFeature.prioritySupport:
        return isPremiumUser;
      
      // Features gratuitas
      case PremiumFeature.basicReports:
      case PremiumFeature.localBackup:
      case PremiumFeature.basicGoals:
        return true;
    }
  }

  // Mensagens para features bloqueadas
  static String getFeatureBlockedMessage(PremiumFeature feature) {
    switch (feature) {
      case PremiumFeature.cloudSync:
        return 'Sincronização na nuvem disponível apenas no Premium';
      case PremiumFeature.multiDevice:
        return 'Acesso multi-dispositivo disponível apenas no Premium';
      case PremiumFeature.advancedReports:
        return 'Relatórios avançados disponíveis apenas no Premium';
      case PremiumFeature.pdfExport:
        return 'Exportação PDF disponível apenas no Premium';
      case PremiumFeature.smartAlerts:
        return 'Alertas inteligentes disponíveis apenas no Premium';
      case PremiumFeature.prioritySupport:
        return 'Suporte prioritário disponível apenas no Premium';
      default:
        return 'Este recurso está disponível apenas no Premium';
    }
  }

  // Dados da assinatura
  static Future<Map<String, dynamic>?> getSubscriptionData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_subscriptionKey);
    if (data != null) {
      return Map<String, dynamic>.from(
        // ignore: avoid_dynamic_calls
        (await import('dart:convert')).jsonDecode(data),
      );
    }
    return null;
  }

  static Future<void> _saveSubscriptionData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_subscriptionKey, 
      (await import('dart:convert')).jsonEncode(data));
  }

  static Future<void> _clearSubscriptionData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_subscriptionKey);
  }

  // Sincronização
  static Future<void> markLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }

  static Future<DateTime?> getLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSync = prefs.getString(_lastSyncKey);
    if (lastSync != null) {
      return DateTime.parse(lastSync);
    }
    return null;
  }

  // Estatísticas de uso
  static Future<Map<String, dynamic>> getUsageStats() async {
    final isPremiumUser = await isPremium();
    final lastSync = await getLastSync();
    final subscriptionData = await getSubscriptionData();
    
    return {
      'is_premium': isPremiumUser,
      'last_sync': lastSync?.toIso8601String(),
      'subscription_active': subscriptionData != null,
      'features_available': _getAvailableFeatures(isPremiumUser).length,
      'subscription_data': subscriptionData,
    };
  }

  static List<PremiumFeature> _getAvailableFeatures(bool isPremium) {
    if (isPremium) {
      return PremiumFeature.values;
    } else {
      return [
        PremiumFeature.basicReports,
        PremiumFeature.localBackup,
        PremiumFeature.basicGoals,
      ];
    }
  }
}

class PremiumStatus {
  final bool isPremium;
  final bool isOnline;
  final String message;
  final Map<String, dynamic>? subscriptionData;

  PremiumStatus({
    required this.isPremium,
    required this.isOnline,
    required this.message,
    this.subscriptionData,
  });
}

class SubscriptionResult {
  final bool success;
  final String message;
  final String? paymentUrl;

  SubscriptionResult({
    required this.success,
    required this.message,
    this.paymentUrl,
  });
}

enum PremiumFeature {
  cloudSync,
  multiDevice,
  advancedReports,
  pdfExport,
  smartAlerts,
  prioritySupport,
  basicReports,
  localBackup,
  basicGoals,
}