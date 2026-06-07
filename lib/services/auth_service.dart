import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  static String? _accessToken;
  static String? _refreshToken;
  static String? _role;

  final String baseUrl = ApiService.baseUrl;

  // ================= GETTERS =================
  static String? get accessToken => _accessToken;
  static String? get refreshToken => _refreshToken;
  static String? get role => _role;
  static bool get isLoggedIn => _accessToken != null;

  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();

    _accessToken = prefs.getString("access_token");
    _refreshToken = prefs.getString("refresh_token");
    _role = prefs.getString("role");
  }

  Future<String?> getValidAccessToken() async {
    if (_accessToken != null) return _accessToken;

    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString("access_token");

    return _accessToken;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String room,
  }) async {
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

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final accessToken = data["access_token"];
      final refreshToken = data["refresh_token"];
      final hasFace = data["user"]["has_face_registered"] == true;
      final role = data["user"]["role"];

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("access_token", accessToken);
      await prefs.setString("refresh_token", refreshToken);
      await prefs.setBool("has_face", hasFace);
      await prefs.setString("role", role);

      _accessToken = accessToken;
      _refreshToken = refreshToken;
      _role = data["user"]["role"];

      return data;
    }

    return null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("access_token");
    await prefs.remove("refresh_token");
    await prefs.remove("role");

    _accessToken = null;
    _refreshToken = null;
    _role = null;
  }

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

  Future<void> setHasFace(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_face', value);
  }

  Future<bool> getHasFace() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('has_face') ?? false;
  }
}
