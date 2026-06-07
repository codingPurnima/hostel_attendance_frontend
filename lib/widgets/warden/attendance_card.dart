import 'package:flutter/material.dart';

class AttendanceCard extends StatelessWidget {
  final List<dynamic> attendance;
  const AttendanceCard({super.key, required this.attendance});

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
            "Today's Attendance",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text("Student ID")),
                DataColumn(label: Text("Room")),
                DataColumn(label: Text("Status")),
              ],
              rows: attendance.map((a) {

              return DataRow(
                cells: [

                  DataCell(
                    Text(a["student_id"].toString()),
                  ),

                  DataCell(
                    Text(a["room"].toString()),
                  ),

                  DataCell(
                    Text(a["status"].toString()),
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
