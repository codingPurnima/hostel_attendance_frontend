import 'package:flutter/material.dart';
import 'package:hostel_attendance_frontend/services/leave_service.dart';
import 'package:hostel_attendance_frontend/widgets/leave_model.dart';
import 'package:hostel_attendance_frontend/widgets/build_leave_card.dart';

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
                  return LeaveCard(leave: leaves[index]);
                },
              ),
            ),
      
    );
  }
}
