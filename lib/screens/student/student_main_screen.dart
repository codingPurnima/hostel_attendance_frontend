import 'package:flutter/material.dart';
import 'package:hostel_attendance_frontend/screens/common/main_screen.dart';
import 'package:hostel_attendance_frontend/screens/student/leave_screen.dart';
import 'package:hostel_attendance_frontend/screens/student/show_history.dart';
import 'package:hostel_attendance_frontend/screens/student/show_profile.dart';
import 'package:hostel_attendance_frontend/screens/student/student_home.dart';
import 'package:hostel_attendance_frontend/services/auth_service.dart';

class StudentMainScreen extends StatelessWidget {
  const StudentMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final token = AuthService.accessToken!;

    return MainScreen(
      token: token,
      screens: [
        StudentHome(),
        HistoryScreen(),
        LeaveScreen(token: token),
        ProfileScreen(),
      ],
      navItems: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        BottomNavigationBarItem(
          icon: Icon(Icons.exit_to_app_rounded),
          label: "Leave",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}