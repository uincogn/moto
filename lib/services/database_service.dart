import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/trabalho_model.dart';
import '../models/gasto_model.dart';
import '../models/manutencao_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('motouber.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Tabela de trabalho
    await db.execute('''
      CREATE TABLE trabalho (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data TEXT NOT NULL,
        ganhos REAL NOT NULL,
        km REAL NOT NULL,
        horas REAL NOT NULL,
        observacoes TEXT,
        data_registro TEXT NOT NULL
      )
    ''');

    // Tabela de gastos
    await db.execute('''
      CREATE TABLE gastos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data TEXT NOT NULL,
        categoria TEXT NOT NULL,
        valor REAL NOT NULL,
        descricao TEXT,
        data_registro TEXT NOT NULL
      )
    ''');

    // Tabela de manutenções
    await db.execute('''
      CREATE TABLE manutencoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data TEXT NOT NULL,
        tipo TEXT NOT NULL,
        valor REAL NOT NULL,
        km_atual REAL NOT NULL,
        descricao TEXT,
        data_registro TEXT NOT NULL
      )
    ''');

    // Tabela de configurações
    await db.execute('''
      CREATE TABLE config (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chave TEXT UNIQUE NOT NULL,
        valor TEXT NOT NULL
      )
    ''');

    // Tabela de intervalos de manutenção personalizáveis
    await db.execute('''
      CREATE TABLE intervalos_manutencao (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo TEXT UNIQUE NOT NULL,
        intervalo_km INTEGER NOT NULL DEFAULT 5000
      )
    ''');

    // Inserir configurações padrão
    await _insertDefaultConfig(db);
  }

  Future<void> _insertDefaultConfig(Database db) async {
    final defaultCategories = [
      'Combustível',
      'Alimentação',
      'Pedágio',
      'Estacionamento',
      'Limpeza',
      'Outros'
    ];

    final defaultMaintenanceTypes = [
      'Troca de óleo',
      'Revisão geral',
      'Pneus',
      'Freios',
      'Filtros',
      'Velas',
      'Correia',
      'Outros'
    ];

    await db.insert('config', {
      'chave': 'categorias_gastos',
      'valor': defaultCategories.join(','),
    });

    await db.insert('config', {
      'chave': 'tipos_manutencao',
      'valor': defaultMaintenanceTypes.join(','),
    });

    // Inserir intervalos padrão de manutenção
    final defaultIntervals = {
      'Troca de óleo': 3000,
      'Revisão geral': 5000,
      'Pneus': 10000,
      'Freios': 8000,
      'Filtros': 6000,
      'Velas': 12000,
      'Correia': 15000,
      'Relação': 5000,
      'Óleo de freio': 5000,
      'Outros': 5000,
    };

    for (var entry in defaultIntervals.entries) {
      await db.insert('intervalos_manutencao', {
        'tipo': entry.key,
        'intervalo_km': entry.value,
      });
    }
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Migração para versão 2: Remover coluna combustível e adicionar tabela de intervalos
      
      // Criar nova tabela de intervalos de manutenção
      await db.execute('''
        CREATE TABLE IF NOT EXISTS intervalos_manutencao (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          tipo TEXT UNIQUE NOT NULL,
          intervalo_km INTEGER NOT NULL DEFAULT 5000
        )
      ''');

      // Verificar se a coluna combustível existe na tabela trabalho
      var tableInfo = await db.rawQuery("PRAGMA table_info(trabalho)");
      bool hasCombustivelColumn = tableInfo.any((column) => column['name'] == 'combustivel');

      if (hasCombustivelColumn) {
        // Migrar dados para nova estrutura (sem coluna combustível)
        await db.execute('''
          CREATE TABLE trabalho_new (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            data TEXT NOT NULL,
            ganhos REAL NOT NULL,
            km REAL NOT NULL,
            horas REAL NOT NULL,
            observacoes TEXT,
            data_registro TEXT NOT NULL
          )
        ''');

        // Copiar dados excluindo a coluna combustível
        await db.execute('''
          INSERT INTO trabalho_new (id, data, ganhos, km, horas, observacoes, data_registro)
          SELECT id, data, ganhos, km, horas, observacoes, data_registro FROM trabalho
        ''');

        // Remover tabela antiga e renomear nova
        await db.execute('DROP TABLE trabalho');
        await db.execute('ALTER TABLE trabalho_new RENAME TO trabalho');
      }

      // Inserir intervalos padrão de manutenção se não existirem
      final defaultIntervals = {
        'Troca de óleo': 3000,
        'Revisão geral': 5000,
        'Pneus': 10000,
        'Freios': 8000,
        'Filtros': 6000,
        'Velas': 12000,
        'Correia': 15000,
        'Relação': 5000,
        'Óleo de freio': 5000,
        'Outros': 5000,
      };

      for (var entry in defaultIntervals.entries) {
        await db.insert(
          'intervalos_manutencao',
          {'tipo': entry.key, 'intervalo_km': entry.value},
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    }
  }

  Future<void> init() async {
    await database;
  }

  // Métodos para trabalho
  Future<int> insertTrabalho(TrabalhoModel trabalho) async {
    final db = await database;
    return await db.insert('trabalho', trabalho.toMap());
  }

  Future<List<TrabalhoModel>> getTrabalhos({DateTime? dataInicio, DateTime? dataFim}) async {
    final db = await database;
    String where = '';
    List<dynamic> whereArgs = [];

    if (dataInicio != null && dataFim != null) {
      where = 'DATE(data) BETWEEN ? AND ?';
      whereArgs = [dataInicio.toIso8601String().split('T')[0], dataFim.toIso8601String().split('T')[0]];
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'trabalho',
      where: where.isNotEmpty ? where : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'data DESC',
    );
    
    // Debug log
    if (dataInicio != null && dataFim != null) {
      print('=== DEBUG DATABASE TRABALHOS ===');
      print('Query WHERE: $where');
      print('Query Args: $whereArgs');
      print('Resultados encontrados: ${maps.length}');
      if (maps.isNotEmpty) {
        print('Primeira data encontrada: ${maps.first['data']}');
      }
    }

    return List.generate(maps.length, (i) => TrabalhoModel.fromMap(maps[i]));
  }

  Future<int> updateTrabalho(TrabalhoModel trabalho) async {
    final db = await database;
    return await db.update(
      'trabalho',
      trabalho.toMap(),
      where: 'id = ?',
      whereArgs: [trabalho.id],
    );
  }

  Future<int> deleteTrabalho(int id) async {
    final db = await database;
    return await db.delete(
      'trabalho',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos para gastos
  Future<int> insertGasto(GastoModel gasto) async {
    final db = await database;
    return await db.insert('gastos', gasto.toMap());
  }

  Future<List<GastoModel>> getGastos({DateTime? dataInicio, DateTime? dataFim}) async {
    final db = await database;
    String where = '';
    List<dynamic> whereArgs = [];

    if (dataInicio != null && dataFim != null) {
      where = 'DATE(data) BETWEEN ? AND ?';
      whereArgs = [dataInicio.toIso8601String().split('T')[0], dataFim.toIso8601String().split('T')[0]];
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'gastos',
      where: where.isNotEmpty ? where : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'data DESC',
    );

    return List.generate(maps.length, (i) => GastoModel.fromMap(maps[i]));
  }

  Future<int> updateGasto(GastoModel gasto) async {
    final db = await database;
    return await db.update(
      'gastos',
      gasto.toMap(),
      where: 'id = ?',
      whereArgs: [gasto.id],
    );
  }

  Future<int> deleteGasto(int id) async {
    final db = await database;
    return await db.delete(
      'gastos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos para manutenções
  Future<int> insertManutencao(ManutencaoModel manutencao) async {
    final db = await database;
    return await db.insert('manutencoes', manutencao.toMap());
  }

  Future<List<ManutencaoModel>> getManutencoes({DateTime? dataInicio, DateTime? dataFim}) async {
    final db = await database;
    String where = '';
    List<dynamic> whereArgs = [];

    if (dataInicio != null && dataFim != null) {
      where = 'DATE(data) BETWEEN ? AND ?';
      whereArgs = [dataInicio.toIso8601String().split('T')[0], dataFim.toIso8601String().split('T')[0]];
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'manutencoes',
      where: where.isNotEmpty ? where : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'data DESC',
    );

    return List.generate(maps.length, (i) => ManutencaoModel.fromMap(maps[i]));
  }

  Future<int> updateManutencao(ManutencaoModel manutencao) async {
    final db = await database;
    return await db.update(
      'manutencoes',
      manutencao.toMap(),
      where: 'id = ?',
      whereArgs: [manutencao.id],
    );
  }

  Future<int> deleteManutencao(int id) async {
    final db = await database;
    return await db.delete(
      'manutencoes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos para configurações
  Future<String?> getConfig(String chave) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'config',
      where: 'chave = ?',
      whereArgs: [chave],
    );

    if (maps.isNotEmpty) {
      return maps.first['valor'];
    }
    return null;
  }

  Future<void> setConfig(String chave, String valor) async {
    final db = await database;
    await db.insert(
      'config',
      {'chave': chave, 'valor': valor},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<String>> getCategoriasGastos() async {
    final categorias = await getConfig('categorias_gastos');
    return categorias?.split(',') ?? [];
  }

  Future<List<String>> getTiposManutencao() async {
    final tipos = await getConfig('tipos_manutencao');
    return tipos?.split(',') ?? [];
  }

  Future<void> setCategoriasGastos(List<String> categorias) async {
    await setConfig('categorias_gastos', categorias.join(','));
  }

  Future<void> setTiposManutencao(List<String> tipos) async {
    await setConfig('tipos_manutencao', tipos.join(','));
  }

  // Novos métodos para suporte a GoalsService e BackupService
  Future<List<TrabalhoModel>> getAllTrabalhos() async {
    final db = await database;
    final maps = await db.query('trabalho', orderBy: 'data DESC');
    return maps.map((map) => TrabalhoModel.fromMap(map)).toList();
  }

  Future<List<GastoModel>> getAllGastos() async {
    final db = await database;
    final maps = await db.query('gastos', orderBy: 'data DESC');
    return maps.map((map) => GastoModel.fromMap(map)).toList();
  }

  Future<List<ManutencaoModel>> getAllManutencoes() async {
    final db = await database;
    final maps = await db.query('manutencoes', orderBy: 'data DESC');
    return maps.map((map) => ManutencaoModel.fromMap(map)).toList();
  }

  Future<List<TrabalhoModel>> getTrabalhosByPeriod(DateTime start, DateTime end) async {
    final db = await database;
    final maps = await db.query(
      'trabalho',
      where: 'data BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String().split('T')[0], end.toIso8601String().split('T')[0]],
      orderBy: 'data DESC',
    );
    return maps.map((map) => TrabalhoModel.fromMap(map)).toList();
  }

  // Métodos para intervalos de manutenção
  Future<int> getIntervaloManutencao(String tipo) async {
    final db = await database;
    final maps = await db.query(
      'intervalos_manutencao',
      where: 'tipo = ?',
      whereArgs: [tipo],
    );
    
    if (maps.isNotEmpty) {
      return maps.first['intervalo_km'] as int;
    }
    return 5000; // Valor padrão
  }

  Future<void> setIntervaloManutencao(String tipo, int intervalokm) async {
    final db = await database;
    await db.insert(
      'intervalos_manutencao',
      {'tipo': tipo, 'intervalo_km': intervalokm},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, int>> getAllIntervalosManutencao() async {
    final db = await database;
    final maps = await db.query('intervalos_manutencao');
    
    Map<String, int> intervalos = {};
    for (var map in maps) {
      intervalos[map['tipo'] as String] = map['intervalo_km'] as int;
    }
    return intervalos;
  }

  Future<double> calcularProximaManutencao(String tipo, double kmAtual) async {
    final intervalo = await getIntervaloManutencao(tipo);
    return kmAtual + intervalo;
  }

  Future<List<GastoModel>> getGastosByPeriod(DateTime start, DateTime end) async {
    final db = await database;
    final maps = await db.query(
      'gastos',
      where: 'data BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String().split('T')[0], end.toIso8601String().split('T')[0]],
      orderBy: 'data DESC',
    );
    return maps.map((map) => GastoModel.fromMap(map)).toList();
  }

  Future<List<ManutencaoModel>> getManutencoesByPeriod(DateTime start, DateTime end) async {
    final db = await database;
    final maps = await db.query(
      'manutencoes',
      where: 'data BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String().split('T')[0], end.toIso8601String().split('T')[0]],
      orderBy: 'data DESC',
    );
    return maps.map((map) => ManutencaoModel.fromMap(map)).toList();
  }

  Future<void> clearAllData() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('trabalho');
      await txn.delete('gastos');
      await txn.delete('manutencoes');
      // Não limpar config para manter configurações do usuário
    });
  }

  // Método de inicialização já existe na linha 115-117
}