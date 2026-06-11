import 'package:flutter/material.dart';
import 'package:hostel_attendance_frontend/services/leave_service.dart';
import 'package:hostel_attendance_frontend/widgets/leave_model.dart';
import 'package:hostel_attendance_frontend/widgets/build_leave_card.dart';
import 'package:hostel_attendance_frontend/screens/student/create_leave_screen.dart';

class LeaveScreen extends StatefulWidget {
  final String token;

  const LeaveScreen({super.key, required this.token});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  bool isLoading = true;
  List<LeaveModel> leaves = [];
  @override
  void initState() {
    super.initState();
    fetchLeaves();
  }

  Future<void> fetchLeaves() async {
    final result = await LeaveService.getMyLeaves(token: widget.token);
    if (result["success"]) {
      setState(() {
        leaves = (result["data"] as List)
            .map((json) => LeaveModel.fromJson(json))
            .toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result["message"])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leaves")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : leaves.isEmpty
          ? const Center(child: Text("No leave requests found"))
          : RefreshIndicator(
              onRefresh: fetchLeaves,
              child: ListView.builder(
                itemCount: leaves.length,
                itemBuilder: (context, index) {
                  final leave = leaves[index];
                  return LeaveCard(
                    leave: leave,
                    onTap: leave.status.toLowerCase() == "pending"
                        ? () async {
                            final shouldCancel = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Cancel Leave"),
                                content: const Text(
                                  "Are you sure you want to cancel this leave?",
                                ),

                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text("No"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text("Yes"),
                                  ),
                                ],
                              ),
                            );
                            if (shouldCancel == true) {
                              final result = await LeaveService.cancelLeave(
                                token: widget.token,
                                leaveId: leave.id,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result["message"])),
                              );

                              if (result["success"]) {
                                fetchLeaves();
                              }
                            }
                          }
                        : leave.status.toLowerCase() == "approved"
                        ? () async {
                            final shouldCancel = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Returning Early?"),
                                content: const Text(
                                  "Request warden to end leave period?",
                                ),

                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text("No"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text("Yes"),
                                  ),
                                ],
                              ),
                            );
                            if (shouldCancel == true) {
                              final result = await LeaveService.earlyReturn(
                                token: widget.token,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result["message"])),
                              );

                              if (result["success"]) {
                                fetchLeaves();
                              }
                            }
                          }
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Only pending leaves can be cancelled",
                                ),
                              ),
                            );
                          },
                  );
                },
              ),
            ),

      floatingActionButton: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(30, 0, 5, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: "sortBtn",
              onPressed: () {
                // sorting logic
              },
              child: Icon(Icons.sort),
            ),

            // Create Leave FAB
            FloatingActionButton(
              heroTag: "createBtn",
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateLeaveScreen(token: widget.token),
                  ),
                );
                if (result == true) {
                  fetchLeaves();
                }
              },
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
