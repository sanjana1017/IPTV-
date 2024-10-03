import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

// Import necessary providers and screens
import 'package:iptv_app/authentication/login/login.dart';
import 'package:iptv_app/features/home/home_page.dart';
import 'package:iptv_app/features/home/tv_route_provider.dart';
import 'package:iptv_app/features/video_player_page/full_screen_state_provider.dart';
import 'package:iptv_app/features/home/drawer/user_details_provider.dart'; // Ensure this path is correct
import 'package:iptv_app/features/home/drawer/Theme_Provider.dart'; // Ensure this path is correct

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = await ThemeProvider.initialize(); // Initialize ThemeProvider
  runApp(MyApp(themeProvider: themeProvider));
}

class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  MyApp({required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TvRouteProvider()),
        ChangeNotifierProvider(create: (_) => FullScreenState()),
        ChangeNotifierProvider(create: (_) => UserDetailsProvider()), // Add UserDetailsProvider
        ChangeNotifierProvider(create: (_) => themeProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'IPTV Test',
            themeMode: themeProvider.themeMode, // Apply theme mode here
            theme: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.blue, // Ensure non-nullable Color
                secondary: Colors.blueAccent, // Ensure non-nullable Color
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent), // Ensure non-nullable Color
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Ensure non-nullable Color
                ),
                labelStyle: TextStyle(color: Colors.black), // Ensure non-nullable Color
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.blueGrey[900]!, // Use `!` to assert non-nullability
                secondary: Colors.blueAccent, // Ensure non-nullable Color
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent), // Ensure non-nullable Color
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Ensure non-nullable Color
                ),
                labelStyle: TextStyle(color: Colors.white), // Ensure non-nullable Color
              ),
            ),
            home: SplashScreen(), // Set SplashScreen as the home
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3)); // Duration for splash screen
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('userId');
    final accessToken = prefs.getString('accessToken');

    Widget nextScreen =
    (id != null && accessToken != null) ? HomePage() : LoginScreen();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
            'assets/animations/VlogCamera.json'), // Path to your Lottie file
      ),
    );
  }
}
