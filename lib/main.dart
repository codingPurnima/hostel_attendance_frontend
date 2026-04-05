import 'package:flutter/material.dart';
import 'package:hostel_attendance_frontend/screens/common/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 6, 24, 39),
        toolbarHeight: 100,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 45,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
    ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF5C6F82),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF5C6F82),
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ), 
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Color(0xFF0E2A47),
          behavior: SnackBarBehavior.fixed,
        ),
      ),
      home: SplashScreen(),
    );
  }
}