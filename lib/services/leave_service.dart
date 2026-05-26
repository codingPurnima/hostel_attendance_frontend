import 'dart:convert';
import 'package:hostel_attendance_frontend/services/api_service.dart';
import 'package:http/http.dart' as http;

class LeaveService {
  static const String baseUrl = ApiService.baseUrl;

  static Future<Map<String, dynamic>> requestLeave({
    required String token,
    required String startDate,
    required String endDate,
    required String reason,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/leave/leave-request"),

        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },

        body: jsonEncode({
          "start_date": startDate,
          "end_date": endDate,
          "reason": reason,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {"success": true, "data": data};
      } else {
        return {
          "success": false,
          "message": data["detail"] ?? "Failed to request leave",
        };
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getMyLeaves({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/leave/my-leaves"),
        headers: {"Authorization": "Bearer $token"},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {"success": true, "data": data};
      } else {
        return {"success": false, "message": "Failed to fetch leaves"};
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  static Future<Map<String, dynamic>> cancelLeave({
    required String token,
    required int leaveId
  }) async{
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/leave/cancel-leave/$leaveId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": data["message"],
        };
      } else {
        return {
          "success": false,
          "message": data["error"] ?? "Failed to cancel leave",
        };
      }
    } catch(e){
      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }
}
