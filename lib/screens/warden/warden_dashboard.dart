import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hostel_attendance_frontend/services/warden_service.dart';
import 'package:hostel_attendance_frontend/widgets/warden/attendance_card.dart';
import 'package:hostel_attendance_frontend/widgets/warden/leave_request_card.dart';
import 'package:hostel_attendance_frontend/widgets/warden/sidebar.dart';
import 'package:hostel_attendance_frontend/widgets/warden/stat_card.dart';
import 'package:hostel_attendance_frontend/widgets/warden/student_card.dart';

class WardenDashboard extends StatefulWidget {
  const WardenDashboard({super.key});

  @override
  State<WardenDashboard> createState() => _WardenDashboardState();
}

class _WardenDashboardState extends State<WardenDashboard> {
  final WardenService service = WardenService();

  // TEMP TOKEN
  String token = "";

  // which detail view to show: 'students' | 'attendance' | 'leave' | 'returns'
  String selectedView = 'students';

  List<dynamic> students = [];
  List<dynamic> attendance = [];
  List<dynamic> leaveRequests = [];
  List<dynamic> returnRequests = [];

  bool isLoading = true;

  Timer? pollingTimer;

  @override
  void initState() {
    super.initState();

    loadDashboard();

    // POLLING EVERY 10 SECONDS
    pollingTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => loadDashboard(),
    );
  }

  @override
  void dispose() {
    pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> loadDashboard() async {
    try {
      final studentsData = await service.getStudents();

      final attendanceData = await service.getTodayAttendance();

      final leaveData = await service.getLeaveRequests();

      final returnData = await service.getReturnRequests();

      setState(() {
        students = studentsData;
        attendance = attendanceData;
        leaveRequests = leaveData;
        returnRequests = returnData;

        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    bool isMobile = size < 900;

    int presentCount = attendance
        .where((e) => e["status"].toString().contains("marked"))
        .length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 24, 39),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        title: const Text("HOSTEL ADMIN", style: TextStyle(fontSize: 40),),
        automaticallyImplyLeading: isMobile,
      ),
      // show Sidebar as a Drawer on mobile, keep it inline on larger screens
      drawer: isMobile
          ? Drawer(
              child: Sidebar(
                selected: selectedView,
                onSelect: (v) {
                  setState(() {
                    selectedView = v;
                  });
                  // close the drawer after selection
                  Navigator.of(context).pop();
                },
              ),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile)
            Sidebar(
              selected: selectedView,
              onSelect: (v) => setState(() {
                selectedView = v;
              }),
            ),

          Expanded(
            child: Column(
              children: [
                // AppBar is provided by Scaffold; removed TopBar usage
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // STATS: use a vertical layout on mobile to avoid infinite/overflow widths
                              if (isMobile)
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    StatCard(
                                      title: "Students",
                                      value: students.length.toString(),
                                      icon: Icons.people,
                                    ),

                                    const SizedBox(height: 12),

                                    StatCard(
                                      title: "Present",
                                      value: presentCount.toString(),
                                      icon: Icons.check_circle,
                                    ),

                                    const SizedBox(height: 12),

                                    StatCard(
                                      title: "Leave Requests",
                                      value: leaveRequests.length.toString(),
                                      icon: Icons.event_busy,
                                    ),

                                    const SizedBox(height: 12),

                                    StatCard(
                                      title: "Returns",
                                      value: returnRequests.length.toString(),
                                      icon: Icons.keyboard_return,
                                    ),
                                  ],
                                )
                              else
                                Wrap(
                                  spacing: 20,
                                  runSpacing: 20,
                                  children: [
                                    StatCard(
                                      title: "Students",
                                      value: students.length.toString(),
                                      icon: Icons.people,
                                    ),

                                    StatCard(
                                      title: "Present",
                                      value: presentCount.toString(),
                                      icon: Icons.check_circle,
                                    ),

                                    StatCard(
                                      title: "Leave Requests",
                                      value: leaveRequests.length.toString(),
                                      icon: Icons.event_busy,
                                    ),

                                    StatCard(
                                      title: "Returns",
                                      value: returnRequests.length.toString(),
                                      icon: Icons.keyboard_return,
                                    ),
                                  ],
                                ),

                              const SizedBox(height: 30),

                              // Show the selected detail view. Stat cards are above and always visible.
                              Builder(
                                builder: (_) {
                                  if (selectedView == 'students') {
                                    return StudentsCard(students: students);
                                  } else if (selectedView == 'attendance') {
                                    return AttendanceCard(
                                      attendance: attendance,
                                    );
                                  } else if (selectedView == 'leave') {
                                    return LeaveRequestsCard(
                                      requests: leaveRequests,
                                      onApprove: (id) async {
                                        try {
                                          await service.approveLeave(id);
                                          await loadDashboard();
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text("Leave Approved"),
                                            ),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                e.toString().replaceFirst(
                                                  "Exception: ",
                                                  "",
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      onReject: (id) async {
                                        try {
                                          await service.rejectLeave(id);
                                          await loadDashboard();
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text("Leave Rejected"),
                                            ),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                e.toString().replaceFirst(
                                                  "Exception: ",
                                                  "",
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  } else if (selectedView == 'returns') {
                                    // Inline simple returns table with Approve action
                                    return Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Return Requests",
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          const SizedBox(height: 20),

                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: DataTable(
                                              columns: const [
                                                DataColumn(
                                                  label: Text("Student ID"),
                                                ),
                                                DataColumn(label: Text("Name")),
                                                DataColumn(
                                                  label: Text("Request Date"),
                                                ),
                                                DataColumn(
                                                  label: Text("Status"),
                                                ),
                                                DataColumn(
                                                  label: Text("Actions"),
                                                ),
                                              ],
                                              rows: returnRequests.map((r) {
                                                return DataRow(
                                                  cells: [
                                                    DataCell(
                                                      Text(
                                                        r["student_id"]
                                                            .toString(),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        r["student_name"]
                                                            .toString(),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        r["request_date"]
                                                            .toString(),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        r["status"].toString(),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          try {
                                                            await service
                                                                .approveReturn(
                                                                  r["id"],
                                                                );
                                                            await loadDashboard();
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                  "Return Approved",
                                                                ),
                                                              ),
                                                            );
                                                          } catch (e) {
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  e
                                                                      .toString()
                                                                      .replaceFirst(
                                                                        "Exception: ",
                                                                        "",
                                                                      ),
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        child: const Text(
                                                          "Approve",
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return const SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
