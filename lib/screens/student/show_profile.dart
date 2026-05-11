import 'package:flutter/material.dart';
import 'package:hostel_attendance_frontend/screens/common/login_screen.dart';
import 'package:hostel_attendance_frontend/services/api_face_service.dart';
import 'package:hostel_attendance_frontend/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;

  Map<String, dynamic>? profileData;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final token = AuthService.accessToken!;

      final result = await FaceService.getProfile(token: token);

      if (result["success"]) {
        setState(() {
          profileData = result["data"];

          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = result["message"];

          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();

        isLoading = false;
      });
    }
  }

  void logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_)=>const LoginScreen()),
      (route)=> false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(fit: BoxFit.scaleDown, child: Text("Student Profile")),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: logout,)
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Student Information",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text("Name: ${profileData!["name"]}"),
                            const SizedBox(height: 16),
                            Text("ID: ${profileData!["id"]}"),
                            const SizedBox(height: 8),
                            Text("Email: ${profileData!["email"]}"),
                            const SizedBox(height: 8),
                            Text("Room: ${profileData!["room"]}"),
                            const SizedBox(height: 8),
                            Text("Status: ${profileData!["status"]}"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
