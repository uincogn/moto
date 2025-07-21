class ManutencaoModel {
  final String? id;
  final String userId;
  final DateTime data;
  final String tipo;
  final double valor;
  final int quilometragem;
  final String? descricao;
  final String? oficina;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ManutencaoModel({
    this.id,
    required this.userId,
    required this.data,
    required this.tipo,
    required this.valor,
    required this.quilometragem,
    this.descricao,
    this.oficina,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'data': data.toIso8601String().split('T')[0], // YYYY-MM-DD
      'tipo': tipo,
      'valor': valor,
      'quilometragem': quilometragem,
      'descricao': descricao,
      'oficina': oficina,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory ManutencaoModel.fromJson(Map<String, dynamic> json) {
    return ManutencaoModel(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString() ?? '',
      data: DateTime.parse(json['data']),
      tipo: json['tipo']?.toString() ?? '',
      valor: (json['valor'] as num?)?.toDouble() ?? 0.0,
      quilometragem: (json['quilometragem'] as num?)?.toInt() ?? 0,
      descricao: json['descricao']?.toString(),
      oficina: json['oficina']?.toString(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  ManutencaoModel copyWith({
    String? id,
    String? userId,
    DateTime? data,
    String? tipo,
    double? valor,
    int? quilometragem,
    String? descricao,
    String? oficina,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ManutencaoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      data: data ?? this.data,
      tipo: tipo ?? this.tipo,
      valor: valor ?? this.valor,
      quilometragem: quilometragem ?? this.quilometragem,
      descricao: descricao ?? this.descricao,
      oficina: oficina ?? this.oficina,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ManutencaoModel(id: $id, userId: $userId, data: $data, tipo: $tipo, valor: $valor, quilometragem: $quilometragem)';
  }
}