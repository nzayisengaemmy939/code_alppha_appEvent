import 'package:code_alpha_campus_event/colors.dart';
import 'package:code_alpha_campus_event/config/app_route.dart'; // Assuming HomePage is imported
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // Import this if you're using JWT tokens

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  String initialRoute = AppRoute.login; // Default to login page

  @override
  void initState() {
    super.initState();
    _checkTokenValidity(); // Check token when the app starts
  }

  Future<void> _checkTokenValidity() async {
    String? token = await getToken();

    if (token != null && !JwtDecoder.isExpired(token)) {
      // If token is valid and not expired, set the initial route to home
      setState(() {
        initialRoute = AppRoute.bottom; // Assuming `AppRoute.home` is the home page route
      });
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token'); // Get token from secure storage
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Poppins",
        scaffoldBackgroundColor: AppColors.background,
      ),
      initialRoute: initialRoute, // Set the initial route based on token validation
      routes: AppRoute.routes, // Define all your app routes here
    );
  }
}
