import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iptv_app/authentication/login/register.dart';
import 'package:iptv_app/authentication/login_services/login_services.dart';
import 'package:iptv_app/features/home/home_page.dart'; // Import HomePage here
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool loginSuccessful = false;
  bool showResultAnimation = false;

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
      showResultAnimation = false;
    });
    try {
      await LoginService.postLoginData(
        phone: int.parse(mobileNumberController.text),
        password: passwordController.text,
        context: context,
      );
      setState(() {
        loginSuccessful = true;
      });
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        loginSuccessful = false;
      });
    } finally {
      setState(() {
        isLoading = false;
        showResultAnimation = true;
      });
      // Show the result animation for 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      if (loginSuccessful) {
        // Navigate to the next page after showing the success animation
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(), // Use HomePage here
          ),
        );
      } else {
        setState(() {
          showResultAnimation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/login.png",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            "Welcome Back!!",
                            style: GoogleFonts.ubuntu(
                              textStyle: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "Kindly login to proceed further",
                              style: GoogleFonts.ubuntu(
                                textStyle: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: mobileNumberController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.call_outlined),
                              hintText: "Mobile Number",
                              hintStyle: GoogleFonts.ubuntu(),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your mobile number';
                              }
                              if (value.length != 10 ||
                                  !RegExp(r'^[0-9]*$').hasMatch(value)) {
                                return 'Mobile number must be exactly 10 digits';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.lock_outline_rounded),
                              hintText: "Password",
                              hintStyle: GoogleFonts.ubuntu(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(250, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: const Color(0xFF6C63FF),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  loginUser();
                                }
                              },
                              child: const Text("Login"),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: GoogleFonts.ubuntu(
                                  textStyle:
                                      const TextStyle(color: Colors.black),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ),
                                ),
                                child: Text(
                                  "Register",
                                  style: GoogleFonts.ubuntu(
                                    textStyle: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xFF6C63FF),
                                      decorationColor: Color(0xFF6C63FF),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Lottie animation at the bottom
                          Center(
                            child: SizedBox(
                              width: 150, // Adjust the width as needed
                              height: 150, // Adjust the height as needed
                              child: Lottie.asset(
                                'assets/animations/Clip.json',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Show result animation conditionally
                          Center(
                            child: SizedBox(
                              width: 150, // Adjust the width as needed
                              height: 0, // Adjust the height as needed
                              child: showResultAnimation
                                  ? (loginSuccessful
                                      ? Lottie.asset(
                                          'assets/animations/Success.json',
                                          fit: BoxFit.cover,
                                        )
                                      : Lottie.asset(
                                          'assets/animations/Error.json',
                                          fit: BoxFit.cover,
                                        ))
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
