import 'package:hostel_attendance_frontend/widgets/leave_model.dart';
import 'package:flutter/material.dart';

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

class LeaveCard extends StatelessWidget {
  final LeaveModel leave;

  const LeaveCard({super.key, required this.leave});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Leave for ${leave.reason}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor(leave.status).withAlpha(38),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    leave.status,
                    style: TextStyle(
                      color: getStatusColor(leave.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text("Start Date: ${leave.startDate}"),
            const SizedBox(height: 6),
            Text("End Date: ${leave.endDate}"),
          ],
        ),
      ),
    );
  }
}
