import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hostel_attendance_frontend/screens/common/register_screen.dart';
import 'package:hostel_attendance_frontend/screens/student/student_main_screen.dart';
import 'package:hostel_attendance_frontend/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onLoginPressed() async {
    if (_formKey.currentState!.validate()) {
      final authService = AuthService();

      final result = await authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (result != null) {
        final accessToken = result["access_token"];
        final bool hasFace = result["has_face"];
        // final role = result["role"]; LATER

        if (accessToken != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StudentMainScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Login failed")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 6, 24, 39),
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            CircleAvatar(
              radius: 75,
              backgroundColor: Colors.grey[300],
              child: Text("Logo"),
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "you@yourid.com",
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your email id";
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return "Invalid email id";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 9),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "asCjiV34%#",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter password";
                      }
                      if (value.length < 8) {
                        return "Password must be at least 8 characters";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: _onLoginPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 6, 24, 39),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 5,
                      ),
                      fixedSize: Size(125, 15),
                      elevation: 5,
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: "Not registered? ",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                      children: [
                        TextSpan(
                          text: 'Create Account',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 20,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate to Login Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFDCE6F1),
    );
  }
}
