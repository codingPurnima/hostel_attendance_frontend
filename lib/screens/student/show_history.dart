import 'dart:async';
import 'dart:convert';

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

    timer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => loadAttendance(silent: true),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> loadAttendance({bool silent = false}) async {
    if (!silent) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      final token = AuthService.accessToken;
      if (token == null) return;
      final result = await FaceService.getAttendance(token: token);
      if (!mounted) return;
      
      if (result["success"]) {
        final newData = result["data"];
        if (jsonEncode(newData) != jsonEncode(attendanceData)) {
          setState(() {
            attendanceData = result["data"];
            errorMessage = null;
          });
        }
      } else {
        if (!mounted) return;
        setState(() {
          errorMessage = result["message"];
        });
      }
    } catch (e) {
      if (!mounted) return;
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
        elevation: 0,
        centerTitle: true,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: const Text("Attendance History"),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : attendanceData.isEmpty
          ? const Center(child: Text("No attendance records found"))
          : RefreshIndicator(
              onRefresh: () => loadAttendance(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView.separated(
                  itemCount: attendanceData.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = attendanceData[index];

                    return Card(
                      elevation: 1.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFE8F5E9),
                          child: Icon(
                            Icons.check_circle,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
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
