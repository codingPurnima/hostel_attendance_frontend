import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  static String? _accessToken;
  static String? _refreshToken;

  final String baseUrl = ApiService.baseUrl;

  static bool get isLoggedIn => _accessToken != null;

  // ================= LOAD TOKENS =================
  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString("access_token");
    _refreshToken = prefs.getString("refresh_token");
  }

  // ================= REGISTER =================
  Future<bool> register(
      {required String name, required String email, required String password, required String room}) async {
      final response = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "room": room,
        "email": email,
        "password": password,        
      }),
    );

    return response.statusCode == 201;
  }

  // ================= LOGIN =================
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final accessToken = data["access_token"];
      final refreshToken = data["refresh_token"];

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("access_token", accessToken);
      await prefs.setString("refresh_token", refreshToken);

      _accessToken = accessToken;
      _refreshToken = refreshToken;

      return data;
    }

    return null;
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    _accessToken = null;
    _refreshToken = null;
  }

  // ================= REFRESH TOKEN =================
  Future<String?> refreshAccessToken() async {
    // use memory first
    String? refreshToken = _refreshToken;

    // fallback to storage
    if (refreshToken == null) {
      final prefs = await SharedPreferences.getInstance();
      refreshToken = prefs.getString("refresh_token");
    }

    if (refreshToken == null) return null;

    final response = await http.post(
      Uri.parse("$baseUrl/refresh"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"refresh_token": refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newAccessToken = data["access_token"];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("access_token", newAccessToken);

      // update memory
      _accessToken = newAccessToken;

      return newAccessToken;
    }

    return null;
  }

  // ================= GETTERS =================
  static String? get accessToken => _accessToken;
  static String? get refreshToken => _refreshToken;
}