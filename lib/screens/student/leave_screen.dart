import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hostel_attendance_frontend/services/leave_service.dart';

class LeaveScreen extends StatefulWidget {
  final String token;

  const LeaveScreen({super.key, required this.token});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  bool isLoading = true;
  List leaves = [];
  @override
  void initState() {
    super.initState();
    fetchLeaves();
  }

  Future<void> fetchLeaves() async {
    final result = await LeaveService.getMyLeaves(token: widget.token);
    if (result["success"]) {
      setState(() {
        leaves = result["data"];
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

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
        return Colors.green;

      case "rejected":
        return Colors.red;

      case "pending":
        return Colors.orange;

      case "cancelled":
        return Colors.lightGreen;

      default:
        return Colors.grey;
    }
  }

  Widget buildLeaveCard(dynamic leave) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      child: Padding(

        padding: const EdgeInsets.all(14),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Row(

              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [

                Text(
                  "Leave #${leave["id"]}",

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Container(

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: getStatusColor(
                      leave["status"],
                    ).withValues(alpha: 0.15),

                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Text(

                    leave["status"],

                    style: TextStyle(
                      color: getStatusColor(
                        leave["status"],
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Text(
              "Start Date: ${leave["start_date"]}",
            ),

            const SizedBox(height: 6),

            Text(
              "End Date: ${leave["end_date"]}",
            ),

            const SizedBox(height: 10),

            const Text(
              "Reason",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),Text(
              leave["reason"] ?? "",
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leaves"),),
      body: isLoading
      ? const Center(child: CircularProgressIndicator(),)
      : leaves.isEmpty
      ? const Center(child: Text("No leave requests found"),)
      : RefreshIndicator(

        onRefresh: fetchLeaves,
        child: ListView.builder(
          itemCount: leaves.length,
          itemBuilder: (context, index) {
            return buildLeaveCard(
              leaves[index],
            );
          },
        ),
      ),      
    );
  }
}
