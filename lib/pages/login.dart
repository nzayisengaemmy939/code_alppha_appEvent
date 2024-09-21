import 'dart:convert';

import 'package:code_alpha_campus_event/app_styles.dart';
import 'package:code_alpha_campus_event/bankend.dart';
import 'package:code_alpha_campus_event/colors.dart';
import 'package:code_alpha_campus_event/config/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
var baseUrl=Bankend.link;
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}
var email="";
var password="";
bool isLoading=false;

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.single,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.font2,
        title: const Text("Login"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                TextField(
                   onChanged: (value) {
                   email = value;
                  },
                  decoration: InputDecoration(
                    
                    hintText: "Email",
                    hintStyle: const TextStyle(color: AppColors.font2),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    hoverColor: AppColors.font1,
                    fillColor: AppColors.single,
                    prefixIcon: const Icon(Icons.email, color: Color(0xFF1A73E9)),
                  ),
                  style: const TextStyle(
                    color: AppColors.font2, // Change the text color to blue
                    fontSize: 16, // Customize font size
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                   onChanged: (value) {
                   password = value;
                  },
                  decoration: const InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    hoverColor: AppColors.font1,
                    fillColor: AppColors.single,
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF1A73E9)),
                  ),
                  style: const TextStyle(
                    color: AppColors.font2, // Change the text color to blue
                    fontSize: 16, // Customize font size
                  ),
                    obscureText: true,

              
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                       if (!isLoading) {
                          doLogin(
                          password, email);
                        }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.single,
                      side: const BorderSide(
                        width: 1,
                        color: AppColors.font1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: isLoading
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: Colors.white),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Register",
                                style: TextStyle(color: AppColors.font2),
                              ),
                            ],
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(color: AppColors.font2),
                          ),
                  ),
                ),
                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                     IconButton(
                        onPressed: () {},
                        icon: const Text(
                          "Forgot Password",
                          style: TextStyle(
                              color: AppColors.font2,
                              fontSize: AppStyles.fontsize2),
                        )),
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoute.register);
                        },
                        icon: const Text(
                          "Register",
                          style: TextStyle(
                              color: AppColors.pressedButton,
                              fontSize: AppStyles.fontsize2),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
 Future<void> doLogin(String email, String password) async {
    final FlutterSecureStorage storage = FlutterSecureStorage(); 
  setState(() {
    isLoading = true;
  });

  final response = await http.post(
    Uri.parse('${baseUrl}/users/login'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );

  setState(() {
    isLoading = false;
  });

  if (response.statusCode == 200) {
    try {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        // Store token securely
        await storage.write(key: 'token', value: data['token']);
        _showSuccessDialog(context, "Success", data['message']);
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, AppRoute.home); // Redirect to home or dashboard
        });
      } else {
        _showErrorDialog(context, "Error", data['message']);
      }
    } catch (e) {
      _showErrorDialog(context, "Error", "Error parsing response: $e");
    }
  } else {
    try {
      final dat = jsonDecode(response.body);
      _showErrorDialog(context, "Error", dat["message"]);
    } catch (e) {
      _showErrorDialog(context, "Error", "Unexpected error: $e");
    }
  }
}

void _showErrorDialog(BuildContext context,String text, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text),
          content: Text(message,style: TextStyle(color: AppColors.red),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
void _showSuccessDialog(BuildContext context,String text, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title:  Text(text),
        content: Text(message,style: TextStyle(color: Colors.green),),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              // Navigate to the login screen
              Navigator.pushNamed(context, AppRoute.login); // Adjust the route name as needed
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}
}

