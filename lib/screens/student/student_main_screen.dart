import 'package:flutter/material.dart';
import 'package:hostel_attendance_frontend/screens/common/main_screen.dart';
import 'package:hostel_attendance_frontend/screens/student/show_history.dart';
import 'package:hostel_attendance_frontend/screens/student/show_profile.dart';
import 'package:hostel_attendance_frontend/screens/student/student_home.dart';

class StudentMainScreen extends StatelessWidget {
  const StudentMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScreen(
      screens: const [StudentHome(), ShowHistory(), ShowProfile()], navItems: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ]
    );
  }
}