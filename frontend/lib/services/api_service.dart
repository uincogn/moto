import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // static const String _baseUrl = 'https://api.kmdollar.com'; // Produção  
  static const String _baseUrl = 'http://localhost:3000'; // Desenvolvimento local
  // Nota: Backend rodando em localhost:3000 (HTTP para desenvolvimento)
  
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Headers padrão
  static Map<String, String> get _defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Headers com autorização
  static Future<Map<String, String>> get _authHeaders async {
    final token = await getToken();
    return {
      ..._defaultHeaders,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Gerenciamento de token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Gerenciamento de usuário
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return jsonDecode(userJson) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(userData));
  }

  // Autenticação
  static Future<ApiResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/register'),
        headers: _defaultHeaders,
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Erro de conexão: $e',
      );
    }
  }

  static Future<ApiResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        headers: _defaultHeaders,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final result = _handleResponse(response);
      
      // Salvar token e dados do usuário se login foi bem-sucedido
      if (result.success && result.data != null) {
        if (result.data!['token'] != null) {
          await saveToken(result.data!['token']);
        }
        if (result.data!['user'] != null) {
          await saveUserData(result.data!['user']);
        }
      }

      return result;
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Erro de conexão: $e',
      );
    }
  }

  static Future<ApiResponse> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/logout'),
        headers: await _authHeaders,
      );

      await removeToken();
      return _handleResponse(response);
    } catch (e) {
      // Mesmo que falhe no servidor, remove token localmente
      await removeToken();
      return ApiResponse(
        success: false,
        message: 'Erro de conexão: $e',
      );
    }
  }

  static Future<ApiResponse> getMe() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/auth/me'),
        headers: await _authHeaders,
      );

      final result = _handleResponse(response);
      
      // Atualizar dados do usuário se bem-sucedido
      if (result.success && result.data != null) {
        await saveUserData(result.data!);
      }

      return result;
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Erro de conexão: $e',
      );
    }
  }

  // Premium
  static Future<ApiResponse> checkPremiumStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/premium/status'),
        headers: await _authHeaders,
      );

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Erro de conexão: $e',
      );
    }
  }

  static Future<ApiResponse> createPremiumSubscription() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/premium/subscribe'),
        headers: await _authHeaders,
      );

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Erro de conexão: $e',
      );
    }
  }

  static Future<ApiResponse> cancelPremiumSubscription() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/premium/cancel'),
        headers: await _authHeaders,
      );

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Erro de conexão: $e',
      );
    }
  }

  // Backup
  static Future<ApiResponse> uploadBackup(Map<String, dynamic> backupData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/backup/upload'),
        headers: await _authHeaders,
        body: jsonEncode(backupData),
      );

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Erro de conexão: $e',
      );
    }
  }

  static Future<ApiResponse> downloadBackup() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/backup/download'),
        headers: await _authHeaders,
      );

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Erro de conexão: $e',
      );
    }
  }

  // Helper para processar respostas
  static ApiResponse _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      
      return ApiResponse(
        success: response.statusCode >= 200 && response.statusCode < 300,
        statusCode: response.statusCode,
        message: data['message'] as String? ?? 'Operação realizada',
        data: data,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: response.statusCode,
        message: 'Erro ao processar resposta: $e',
      );
    }
  }

  // Verificar conectividade
  static Future<bool> isOnline() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/health'),
        headers: _defaultHeaders,
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

class ApiResponse {
  final bool success;
  final int? statusCode;
  final String message;
  final Map<String, dynamic>? data;

  ApiResponse({
    required this.success,
    this.statusCode,
    required this.message,
    this.data,
  });

  @override
  String toString() {
    return 'ApiResponse(success: $success, statusCode: $statusCode, message: $message)';
  }
}