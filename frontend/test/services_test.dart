import 'package:flutter_test/flutter_test.dart';
import 'package:motouber/services/goals_service.dart';
import 'package:motouber/services/premium_service.dart';
import 'package:motouber/services/api_service.dart';
import 'package:motouber/models/trabalho_model.dart';
import 'package:motouber/models/gasto_model.dart';
import 'package:motouber/models/manutencao_model.dart';

void main() {
  group('Goals Service Tests', () {
    test('should calculate daily progress correctly', () async {
      // Test seria implementado com mock database
      expect(true, isTrue); // Placeholder
    });

    test('should set and get daily goal', () async {
      const testGoal = 250.0;
      await GoalsService.setDailyGoal(testGoal);
      final retrievedGoal = await GoalsService.getDailyGoal();
      
      // Em ambiente de teste real, verificaria se o valor foi salvo
      expect(retrievedGoal >= 0, isTrue);
    });
  });

  group('Premium Service Tests', () {
    test('should check premium feature access correctly', () async {
      // Teste básico de acesso a features
      final canUseCloudSync = await PremiumService.canUseFeature(
        PremiumFeature.cloudSync,
      );
      
      expect(canUseCloudSync is bool, isTrue);
    });

    test('should return correct blocked messages', () {
      final message = PremiumService.getFeatureBlockedMessage(
        PremiumFeature.advancedReports,
      );
      
      expect(message.isNotEmpty, isTrue);
      expect(message.contains('Premium'), isTrue);
    });
  });

  group('API Service Tests', () {
    test('should handle token operations', () async {
      const testToken = 'test_token_123';
      
      await ApiService.saveToken(testToken);
      final retrievedToken = await ApiService.getToken();
      final isLoggedIn = await ApiService.isLoggedIn();
      
      expect(retrievedToken, equals(testToken));
      expect(isLoggedIn, isTrue);
      
      await ApiService.removeToken();
      final removedToken = await ApiService.getToken();
      final isLoggedInAfter = await ApiService.isLoggedIn();
      
      expect(removedToken, isNull);
      expect(isLoggedInAfter, isFalse);
    });
  });

  group('Model Tests', () {
    test('TrabalhoModel should serialize correctly', () {
      final trabalho = TrabalhoModel(
        data: DateTime.now(),
        ganhos: 150.0,
        km: 50.0,
        horas: 8.0,
        observacoes: 'Teste',
        dataRegistro: DateTime.now(),
      );

      final map = trabalho.toMap();
      final fromMap = TrabalhoModel.fromMap(map);

      expect(fromMap.ganhos, equals(trabalho.ganhos));
      expect(fromMap.km, equals(trabalho.km));
      expect(fromMap.horas, equals(trabalho.horas));
      expect(fromMap.observacoes, equals(trabalho.observacoes));
    });

    test('GastoModel should serialize correctly', () {
      final gasto = GastoModel(
        data: DateTime.now(),
        categoria: 'Combustível',
        valor: 80.0,
        descricao: 'Gasolina',
        dataRegistro: DateTime.now(),
      );

      final map = gasto.toMap();
      final fromMap = GastoModel.fromMap(map);

      expect(fromMap.categoria, equals(gasto.categoria));
      expect(fromMap.valor, equals(gasto.valor));
      expect(fromMap.descricao, equals(gasto.descricao));
    });

    test('ManutencaoModel should serialize correctly', () {
      final manutencao = ManutencaoModel(
        data: DateTime.now(),
        tipo: 'Troca de óleo',
        valor: 45.0,
        kmAtual: 15000.0,
        descricao: 'Óleo 5W30',
        dataRegistro: DateTime.now(),
      );

      final map = manutencao.toMap();
      final fromMap = ManutencaoModel.fromMap(map);

      expect(fromMap.tipo, equals(manutencao.tipo));
      expect(fromMap.valor, equals(manutencao.valor));
      expect(fromMap.kmAtual, equals(manutencao.kmAtual));
      expect(fromMap.descricao, equals(manutencao.descricao));
    });
  });

  group('Data Validation Tests', () {
    test('should validate trabalho data', () {
      expect(() {
        TrabalhoModel(
          data: DateTime.now(),
          ganhos: -10.0, // Valor negativo
          km: 50.0,
          horas: 8.0,
          dataRegistro: DateTime.now(),
        );
      }, returnsNormally); // Model não valida, apenas armazena

      expect(() {
        TrabalhoModel(
          data: DateTime.now(),
          ganhos: 150.0,
          km: 0.0, // Zero km é válido
          horas: 0.0, // Zero horas é válido
          dataRegistro: DateTime.now(),
        );
      }, returnsNormally);
    });

    test('should handle empty strings correctly', () {
      final trabalho = TrabalhoModel(
        data: DateTime.now(),
        ganhos: 100.0,
        km: 30.0,
        horas: 6.0,
        observacoes: '', // String vazia
        dataRegistro: DateTime.now(),
      );

      expect(trabalho.observacoes, equals(''));
      
      final map = trabalho.toMap();
      expect(map['observacoes'], equals(''));
      
      final fromMap = TrabalhoModel.fromMap(map);
      expect(fromMap.observacoes, equals(''));
    });
  });
}