import 'package:flutter/material.dart';
import 'package:hostel_attendance_frontend/services/api_face_service.dart';
import 'package:hostel_attendance_frontend/services/auth_service.dart';
import 'package:hostel_attendance_frontend/widgets/logout_helper.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: FittedBox(fit: BoxFit.scaleDown, child: const Text("Student Profile")),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await LogoutHelper.logout(context);
            },
          ),
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
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: const Color(0xFFE0E0E0),
                                  child: Text(
                                    (profileData!['name'] ?? "").isNotEmpty
                                        ? profileData!["name"]![0]
                                              .toString()
                                              .toUpperCase()
                                        : "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 6, 24, 39),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Name: ${profileData!["name"]}"),
                                      const SizedBox(height: 8),
                                      Text("Email: ${profileData!["email"]}"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text("ID: ${profileData!["id"]}"),
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
