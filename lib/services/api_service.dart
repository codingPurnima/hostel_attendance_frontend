import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  final AuthService _authService = AuthService();

  // ================= HEADER =================
  Map<String, String> _headers(String? token) {
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  // ================= GET =================
  Future<http.Response> getRequest(String endpoint) async {
    String? token = AuthService.accessToken;

    var response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers(token),
    );

    if (response.statusCode == 401) {
      final newToken = await _authService.refreshAccessToken();

      if (newToken != null) {
        response = await http.get(
          Uri.parse("$baseUrl$endpoint"),
          headers: _headers(newToken),
        );
      }
    }

    return response;
  }

  // ================= POST =================
  Future<http.Response> postRequest(
      String endpoint, Map<String, dynamic> body) async {
    String? token = AuthService.accessToken;

    var response = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers(token),
      body: jsonEncode(body),
    );

    if (response.statusCode == 401) {
      final newToken = await _authService.refreshAccessToken();

      if (newToken != null) {
        response = await http.post(
          Uri.parse("$baseUrl$endpoint"),
          headers: _headers(newToken),
          body: jsonEncode(body),
        );
      }
    }

    return response;
  }

  // ================= PATCH =================
  Future<http.Response> patchRequest(
      String endpoint, Map<String, dynamic> body) async {
    String? token = AuthService.accessToken;

    var response = await http.patch(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers(token),
      body: jsonEncode(body),
    );

    if (response.statusCode == 401) {
      final newToken = await _authService.refreshAccessToken();

      if (newToken != null) {
        response = await http.patch(
          Uri.parse("$baseUrl$endpoint"),
          headers: _headers(newToken),
          body: jsonEncode(body),
        );
      }
    }

    return response;
  }
}