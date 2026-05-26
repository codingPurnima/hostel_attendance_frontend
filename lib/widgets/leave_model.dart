class LeaveModel {
  final int id;
  final String startDate;
  final String endDate;
  final String reason;
  final String status;

  LeaveModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json["id"],
      startDate: json["start_date"],
      endDate: json["end_date"],
      reason: json["reason"],
      status: json["status"],
    );
  }
}