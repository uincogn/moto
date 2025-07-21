class User {
  final String id;
  final String email;
  final String name;
  final bool isPremium;
  final DateTime createdAt;
  final DateTime? premiumUntil;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.isPremium = false,
    required this.createdAt,
    this.premiumUntil,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      isPremium: json['is_premium'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      premiumUntil: json['premium_until'] != null
          ? DateTime.parse(json['premium_until'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'is_premium': isPremium,
      'created_at': createdAt.toIso8601String(),
      'premium_until': premiumUntil?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    bool? isPremium,
    DateTime? createdAt,
    DateTime? premiumUntil,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      premiumUntil: premiumUntil ?? this.premiumUntil,
    );
  }
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }
}

class RegisterRequest {
  final String email;
  final String password;
  final String name;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
    );
  }
}

class AuthResponse {
  final User user;
  final String token;
  final DateTime expiresAt;

  AuthResponse({
    required this.user,
    required this.token,
    required this.expiresAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
      'expires_at': expiresAt.toIso8601String(),
    };
  }
}