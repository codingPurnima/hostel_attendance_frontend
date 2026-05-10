import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class FaceService {
  static const String baseUrl = "http://10.0.2.2:8000";

  static Future<Map<String, dynamic>> registerFace({
    required String token,
    required File imageFile,
  }) async {
    try {
      var uri = Uri.parse("$baseUrl/face/register");

      var request = http.MultipartRequest("POST", uri);

      request.headers["Authorization"] = "Bearer $token";

      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          imageFile.path,
          filename: basename(imageFile.path),
        ),
      );


      print("REQUEST URL: $uri");
      print("IMAGE PATH: ${imageFile.path}");
      print("TOKEN: $token");

      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"success": true, "data": data};
      } else {
        return {
          "success": false,
          "message": data["error"] ?? data["detail"] ?? "Face registration failed",
        };
      }
    } catch (e) {
          print("EXCEPTION: $e");

      return {"success": false, "message": e.toString()};
    }
  }

  // VERIFY FACE

  static Future<Map<String, dynamic>> verifyFace({
    required int studentId,
    required File imageFile,
  }) async {
    try {
      var uri = Uri.parse("$baseUrl/face/verify");

      var request = http.MultipartRequest("POST", uri);

      request.fields["student_id"] = studentId.toString();

      request.files.add(
        await http.MultipartFile.fromPath(
          "image",
          imageFile.path,
          filename: basename(imageFile.path),
        ),
      );

      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {"success": true, "data": data};
      } else {
        return {
          "success": false,
          "message": data["detail"] ?? "Face verification failed",
        };
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  // MARK ATTENDANCE

  static Future<Map<String, dynamic>> markAttendance({
    required String token,
    required File imageFile,
    required String ssid,
  }) async {
    try {
      var uri = Uri.parse("$baseUrl/attendance/mark");

      var request = http.MultipartRequest("POST", uri);

      request.headers["Authorization"] = "Bearer $token";

      request.fields["ssid"] = ssid;

      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          imageFile.path,
          filename: basename(imageFile.path),
        ),
      );

      print("MARK ATTENDANCE URL: $uri");
    print("SSID: $ssid");

      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"success": true, "data": data};
      } else {
        return {
          "success": false,
          "message": data["error"] ?? "Attendance marking failed",
        };
      }
    } catch (e) {

      print("ATTENDANCE ERROR: $e");
      return {"success": false, "message": e.toString()};
    }
  }


  static Future<Map<String, dynamic>> getAttendance(int studentId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/attendance/student/$studentId"),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {"success": true, "data": data};
      } else {
        return {
          "success": false,
          "message": data["detail"] ?? "Failed to fetch attendance",
        };
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}