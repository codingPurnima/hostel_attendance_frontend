import 'package:flutter/material.dart';

class StudentsCard extends StatelessWidget {
  final List<dynamic> students;
  const StudentsCard({super.key, required this.students});

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
            "Students",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text("ID")),
                DataColumn(label: Text("Room")),
                DataColumn(label: Text("Email")),
                DataColumn(label: Text("Status")),
              ],
              rows: students.map((student) {
            
                return DataRow(
                  cells: [
            
                    DataCell(
                      Text(student["id"].toString()),
                    ),
            
                    DataCell(
                      Text(student["room"].toString()),
                    ),
            
                    DataCell(
                      Text(student["email"].toString()),
                    ),
            
                    DataCell(
                      Text(student["status"].toString()),
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
