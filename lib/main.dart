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
        fontFamily: 'TiroDevanagariHindi',
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 6, 24, 39),
          toolbarHeight: 85,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),


        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF5C6F82), width: 1.5),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF5C6F82), width: 2.5),
            borderRadius: BorderRadius.circular(15),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),


        snackBarTheme: SnackBarThemeData(
          backgroundColor: Color(0xFF0E2A47),
          behavior: SnackBarBehavior.fixed,
        ),


        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromARGB(255, 6, 24, 39),
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.white,
        ),


        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 5,
            minimumSize: Size(0, 52),
            backgroundColor:const Color.fromARGB(255, 6, 24, 39),
            foregroundColor: Colors.white,
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            )
          )
        ),


        dialogTheme: DialogThemeData(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Color(0xFF212121)),
          contentTextStyle: TextStyle(color: Color(0xFF616161)),
        ),


        listTileTheme: ListTileThemeData(
          tileColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Color(0xFF212121),
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          subtitleTextStyle: TextStyle(
            color: Color(0xFF757575),
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ),       
        
        scaffoldBackgroundColor: Color(0xFFE2E8F0),
      ),
      home: SplashScreen(),
    );
  }
}