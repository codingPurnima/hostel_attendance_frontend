import 'dart:convert';
import 'package:hostel_attendance_frontend/services/api_service.dart';
import 'package:hostel_attendance_frontend/services/auth_service.dart';
import 'package:http/http.dart' as http;

class WardenService {
  // CHANGE THIS IF USING EMULATOR
  static const String baseUrl = ApiService.baseUrl;

  Future<List<dynamic>> getStudents() async {
    final token = AuthService.accessToken;
    try {
      print("TOKEN: ${token}");
      final response = await http.get(
        Uri.parse('$baseUrl/warden/students'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load students');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<dynamic>> getTodayAttendance() async {
    final token = AuthService.accessToken;
    final response = await http.get(
      Uri.parse('$baseUrl/warden/attendance/today'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load attendance');
    }
  }

  Future<List<dynamic>> getLeaveRequests() async {
    final token = AuthService.accessToken;
    final response = await http.get(
      Uri.parse('$baseUrl/warden/leave-requests'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load leave requests');
    }
  }

  Future<List<dynamic>> getReturnRequests() async {
    final token = AuthService.accessToken;
    final response = await http.get(
      Uri.parse('$baseUrl/warden/return-requests'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load return requests');
    }
  }

  Future<void> approveLeave(int leaveId) async {
    final token = AuthService.accessToken;
    final response = await http.post(
      Uri.parse('$baseUrl/warden/approve-leave/$leaveId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['detail']);
    }
  }

  Future<void> rejectLeave(int leaveId) async {
    final token = AuthService.accessToken;
    final response = await http.post(
      Uri.parse('$baseUrl/warden/reject-leave/$leaveId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['detail']);
    }
  }

  Future<void> approveReturn(int requestId) async {
    final token = AuthService.accessToken;
    final response = await http.post(
      Uri.parse('$baseUrl/warden/approve-return/$requestId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to approve return');
    }
  }
}
