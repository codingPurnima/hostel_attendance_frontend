import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hostel_attendance_frontend/services/api_face_service.dart';
import 'package:hostel_attendance_frontend/services/auth_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool isLoading = true;

  List<dynamic> attendanceData = [];

  String? errorMessage;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadAttendance();

    timer = Timer.periodic(const Duration(seconds: 5), (_) => loadAttendance());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> loadAttendance() async {
    setState(() {
      isLoading = true;
    });
    try {
      final token = AuthService.accessToken!;
      final result = await FaceService.getAttendance(token: token);
      if (result["success"]) {
        setState(() {
          attendanceData = result["data"];
          errorMessage = null;
        });
      } else {
        setState(() {
          errorMessage = result["message"];
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text("Attendance History"),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : attendanceData.isEmpty
          ? const Center(child: Text("No attendance records found"))
          : RefreshIndicator(
              onRefresh: loadAttendance,
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: ListView.builder(
                  itemCount: attendanceData.length,
                  itemBuilder: (context, index) {
                    final item = attendanceData[index];

                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.check_circle),
                        title: Text("Date: ${item["date"]}"),
                        subtitle: Text("Time: ${item["timestamp"]}"),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
