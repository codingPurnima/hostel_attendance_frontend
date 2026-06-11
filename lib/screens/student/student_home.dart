import 'dart:io';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:hostel_attendance_frontend/services/auth_service.dart';
import 'package:hostel_attendance_frontend/services/api_face_service.dart';
import 'package:image_picker/image_picker.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});
  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  bool? hasFace;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadUserState();
  }

  Future<void> loadUserState() async {
    final value = await AuthService().getHasFace();

    if (!mounted) return;

    setState(() {
      hasFace = value;
    });
  }

  Future<File?> captureImage() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo == null) return null;
    return File(photo.path);
  }

  Future<void> handleRegisterFace() async {
    final image = await captureImage();
    if (image == null) return;

    final token = AuthService.accessToken;
    if (token == null) return;
    print("IMAGE PATH: ${image.path}");
    print("EXISTS: ${await image.exists()}");
    print("SIZE: ${await image.length()}");

    final result = await FaceService.registerFace(
      token: token,
      imageFile: image,
    );
    // update UI after success
    if (result["success"]) {
      await AuthService().setHasFace(true);
      if (!mounted) return;

      setState(() {
        hasFace = true;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Face registered successfully")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result["message"])));
    }
  }

  Future<String> getCurrentSSID() async {
    try {
      await Permission.location.request();

      await Permission.nearbyWifiDevices.request();

      final info = NetworkInfo();
      String? ssid = await info.getWifiName();
      print("RAW SSID: $ssid");

      if (ssid == null) {
        return "";
      }
      ssid = ssid.replaceAll('"', '').trim();
      if (ssid.toLowerCase().contains("unknown")) {
        return "";
      }
      return ssid;
    } catch (e) {
      print("SSID ERROR: $e");
      return "";
    }
  }

  Future<void> handleMarkAttendance() async {
    final image = await captureImage();
    if (image == null) return;

    final token = AuthService.accessToken;
    if (token == null) return;

    final ssid = await getCurrentSSID();
    print("CURRENT SSID: $ssid");

    if (ssid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not detect WiFi network. Try reconnecting"),
        ),
      );
      return;
    }
    print("IMAGE PATH: ${image.path}");
    print("EXISTS: ${await image.exists()}");
    print("SIZE: ${await image.length()}");

    final result = await FaceService.markAttendance(
      token: token,
      imageFile: image,
      ssid: ssid,
    );

    if (result["success"]) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Attendance marked successfully")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result["message"])));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hasFace == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: hasFace!
            ? ElevatedButton(
                onPressed: handleMarkAttendance,
                child: const Text("Mark Attendance"),
              )
            : ElevatedButton(
                onPressed: handleRegisterFace,
                child: const Text("Register Face"),
              ),
      ),
    );
  }
}
