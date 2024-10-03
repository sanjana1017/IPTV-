import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:iptv_app/authentication/login/login.dart';

class RegisterService {
  static const String baseURL =
      'https://iptv-backend-4798.onrender.com/api/user/register';

  static Future<void> registerUser({
    required BuildContext context,
    required String name,
    required String username,
    required String mobileNumber,
    required String email,
    required String password,
  }) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false, // prevents dismissal on tap outside
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF6C63FF),
            ), // Or any other loader widget
          );
        },
      );

      final response = await http.post(
        Uri.parse(baseURL), // Assuming register endpoint
        body: jsonEncode({
          'name': name,
          'username': username,
          'phone': mobileNumber,
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        // Registration successful
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Admin registered successfully!'),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>  LoginScreen(),
          ),
        );
      } else {
        // Registration failed
        debugPrint('Registration failed. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration failed.'),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error registering user: $e');
      // Error occurred
    }
  }
}
