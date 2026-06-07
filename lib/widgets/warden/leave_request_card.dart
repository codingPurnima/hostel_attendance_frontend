import 'package:flutter/material.dart';

class LeaveRequestsCard extends StatelessWidget {
  final List<dynamic> requests;

  final Function(int) onApprove;
  final Function(int) onReject;

  const LeaveRequestsCard({
    super.key,
    required this.requests,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Leave Requests",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text("Student ID")),
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Start")),
                DataColumn(label: Text("End")),
                DataColumn(label: Text("Status")),
                DataColumn(label: Text("  Actions")),
              ],
              rows: requests.map((request) {
                return DataRow(
                  cells: [
                    DataCell(Text(request["student_id"].toString())),
                    DataCell(Text(request["student_name"].toString())),
                    DataCell(Text(request["start_date"].toString())),
                    DataCell(Text(request["end_date"].toString())),
                    DataCell(Text(request["status"].toString())),
                    DataCell(
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => onApprove(request["id"]),
                            child: const Text("Approve"),
                          ),

                          const SizedBox(width: 10),

                          ElevatedButton(
                            onPressed: () => onReject(request["id"]),
                            child: const Text("Reject"),
                          ),
                        ],
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
}
