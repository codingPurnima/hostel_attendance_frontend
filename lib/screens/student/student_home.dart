import 'dart:io';

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

  final int studentId = 1;

  @override
  void initState() {
    super.initState();
    loadUserState();
  }

  Future<void> loadUserState() async {
    final value = await AuthService().getHasFace();
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

    final result = await FaceService.registerFace(
      studentId: studentId,
      imageFile: image,
    );
    // update UI after success
    if (result["success"]) {
      await AuthService().setHasFace(true);

      setState(() {
        hasFace = true;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Face registered successfully")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Face registration failed")));
    }
  }

  Future<void> handleMarkAttendance() async {
    final image = await captureImage();
    if (image == null) return;

    final result = await FaceService.markAttendance(
      studentId: studentId,
      imageFile: image,
    );

    if (result["success"]) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Attendance marked successfully"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result["message"]),
        ),
      );
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
        ? ElevatedButton(onPressed: handleMarkAttendance, child: const Text("Mark Attendance"))
        : ElevatedButton(onPressed: handleRegisterFace, child: const Text("Register Face")),
      )
    );
  }
}
