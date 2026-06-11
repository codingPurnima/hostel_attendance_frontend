import 'package:flutter/material.dart';
import 'package:hostel_attendance_frontend/services/auth_service.dart';
import 'package:hostel_attendance_frontend/services/leave_service.dart';

class CreateLeaveScreen extends StatefulWidget {
  const CreateLeaveScreen({super.key});

  @override
  State<CreateLeaveScreen> createState() => _CreateLeaveScreenState();
}

class _CreateLeaveScreenState extends State<CreateLeaveScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController reasonController = TextEditingController();
  bool isRequestLoading = false;

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  Future<void> pickStartDate() async {
    final picked = await showDatePicker(
      context: context,

      firstDate: DateTime.now(),

      lastDate: DateTime(2030),

      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> pickEndDate() async {
    final picked = await showDatePicker(
      context: context,

      firstDate: startDate ?? DateTime.now(),

      lastDate: DateTime(2030),

      initialDate: startDate ?? DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        endDate = picked;
      });
    }
  }

  Future<void> submitLeaveRequest() async {
    if (startDate == null ||
        endDate == null ||
        reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }
    setState(() {
      isRequestLoading = true;
    });

    final token = AuthService.accessToken;

    if (token == null) {
      return;
    }

    final result = await LeaveService.requestLeave(
      token: token,
      startDate: startDate!.toIso8601String(),
      endDate: endDate!.toIso8601String(),
      reason: reasonController.text.trim(),
    );
    if (!mounted) return;
    setState(() {
      isRequestLoading = false;
    });

    if (result["success"]) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Leave request created")));

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result["message"])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(fit: BoxFit.scaleDown, child: Text("Create Leave")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  startDate == null
                      ? "Select Start Date"
                      : "Start: ${startDate!.toLocal().toString().split(" ")[0]}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: pickStartDate,
              ),

              const SizedBox(height: 10),

              ListTile(
                title: Text(
                  endDate == null
                      ? "Select End Date"
                      : "End: ${endDate!.toLocal().toString().split(" ")[0]}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: pickEndDate,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: reasonController,
                maxLines: 1,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a reason";
                  }

                  if (value.trim().length < 5) {
                    return "Reason is too short";
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Reason",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isRequestLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            // Check dates
                            if (startDate == null || endDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please select dates"),
                                ),
                              );

                              return;
                            }

                            submitLeaveRequest();
                          }
                        },
                  child: isRequestLoading
                      ? const CircularProgressIndicator()
                      : const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
