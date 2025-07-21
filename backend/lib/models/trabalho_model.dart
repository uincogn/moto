class TrabalhoModel {
  final String? id;
  final String userId;
  final DateTime data;
  final double ganhos;
  final int quilometragemInicial;
  final int quilometragemFinal;
  final double horasTrabalhadas;
  final String? observacoes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  TrabalhoModel({
    this.id,
    required this.userId,
    required this.data,
    required this.ganhos,
    required this.quilometragemInicial,
    required this.quilometragemFinal,
    required this.horasTrabalhadas,
    this.observacoes,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'data': data.toIso8601String().split('T')[0], // YYYY-MM-DD
      'ganhos': ganhos,
      'quilometragem_inicial': quilometragemInicial,
      'quilometragem_final': quilometragemFinal,
      'horas_trabalhadas': horasTrabalhadas,
      'observacoes': observacoes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory TrabalhoModel.fromJson(Map<String, dynamic> json) {
    return TrabalhoModel(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString() ?? '',
      data: DateTime.parse(json['data']),
      ganhos: (json['ganhos'] as num?)?.toDouble() ?? 0.0,
      quilometragemInicial: (json['quilometragem_inicial'] as num?)?.toInt() ?? 0,
      quilometragemFinal: (json['quilometragem_final'] as num?)?.toInt() ?? 0,
      horasTrabalhadas: (json['horas_trabalhadas'] as num?)?.toDouble() ?? 0.0,
      observacoes: json['observacoes']?.toString(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  TrabalhoModel copyWith({
    String? id,
    String? userId,
    DateTime? data,
    double? ganhos,
    int? quilometragemInicial,
    int? quilometragemFinal,
    double? horasTrabalhadas,
    String? observacoes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TrabalhoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      data: data ?? this.data,
      ganhos: ganhos ?? this.ganhos,
      quilometragemInicial: quilometragemInicial ?? this.quilometragemInicial,
      quilometragemFinal: quilometragemFinal ?? this.quilometragemFinal,
      horasTrabalhadas: horasTrabalhadas ?? this.horasTrabalhadas,
      observacoes: observacoes ?? this.observacoes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'TrabalhoModel(id: $id, userId: $userId, data: $data, ganhos: $ganhos, quilometragemInicial: $quilometragemInicial, quilometragemFinal: $quilometragemFinal, horasTrabalhadas: $horasTrabalhadas)';
  }
}