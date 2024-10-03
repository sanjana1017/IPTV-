import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iptv_app/features/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static const String apiUrl =
      'https://iptv-backend-4798.onrender.com/api/user/login';

  static Future<void> postLoginData({
    required int phone,
    required String password,
    required BuildContext context,
  }) async {
    final Map<String, dynamic> postData = {
      "phone": phone,
      "password": password,
    };
    showDialog(
      context: context,
      barrierDismissible: false, // prevents dismissal on tap outside
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(), // Or any other loader widget
        );
      },
    );
    // loginProvider.setLoading(true);

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(postData),
    );

    Navigator.of(context).pop();

    if (response.statusCode == 200) {
      // Successful POST request
      debugPrint('Logged In Successful');
      debugPrint('Response body: ${response.body}');
      // Parse the JSON response
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Extract user details
      final Map<String, dynamic> user = responseData['user'];
      final String userId = user['_id'];
      final String accessToken = responseData['accessToken'];
      final String username = user['username'];
      final String name = user['name'];
      final String phone = user['phone'];
      final String email = user['email'];

      // Save user details using shared preferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', userId);
      prefs.setString('accessToken', accessToken);
      prefs.setString('username', username);
      prefs.setString('name', name);
      prefs.setString('phone', phone);
      prefs.setString('email', email);
      /////
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged In successful'),
          duration: Duration(seconds: 2),
        ),
      );
      // loginProvider.setLoading(false);
    } else {
      // Failed POST request
      debugPrint('Failed to send POST request');
      debugPrint('Response status code: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed Log In'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
