import 'dart:convert';
import 'package:code_alpha_campus_event/app_styles.dart';
import 'package:code_alpha_campus_event/bankend.dart';
import 'package:code_alpha_campus_event/colors.dart';
import 'package:code_alpha_campus_event/config/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

var baseUrl = Bankend.link;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "";
  String password = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.single,
      // appBar: AppBar(
      //   backgroundColor: AppColors.background,
      //   foregroundColor: AppColors.font2,
      //   title: const Text("Login"),
      // ),
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
                  decoration: const InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: AppColors.red),
                    ),
                    filled: true,
                    fillColor: AppColors.single,
                    prefixIcon: Icon(Icons.email, color: Color(0xFF1A73E9)),
                  ),
                  style: const TextStyle(
                    color: AppColors.font2,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: const InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: AppColors.red),
                    ),
                    filled: true,
                    fillColor: AppColors.single,
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF1A73E9)),
                  ),
                  style: const TextStyle(
                    color: AppColors.font2,
                    fontSize: 16,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (password == "" && email == "") {
                        _showErrorDialog(
                            context, "Error", "email and password is required");
                      } else {
                        if (!isLoading) {
                          doLogin(email, password);
                        }
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
                               SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Login",
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
                    // TextButton(
                    //   onPressed: () {},
                    //   child: const Text(
                    //     "Forgot Password",
                    //     style: TextStyle(
                    //       color: AppColors.font2,
                    //       fontSize: AppStyles.fontsize2,
                    //     ),
                    //   ),
                    // ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoute.register);
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: AppColors.pressedButton,
                          fontSize: AppStyles.fontsize2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> doLogin(String email, String password) async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    if(email==""&&password==""){
  _showErrorDialog(context, 'error', 'don,t submit empty space');
  return;
}
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
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
 print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          await storage.write(key: 'token', value: data['token']);
          _showSuccessDialog(context, "Success", data['message']);
          password="";
          email="";
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, AppRoute.nav);
          });
        } else {
          _showErrorDialog(context, "Error", data['message']);
        }
      } else {
        final dat = jsonDecode(response.body);
        _showErrorDialog(context, "Error", dat["message"]);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog(context, "Error", "Unexpected error: $e");
    }
  }

  void _showErrorDialog(BuildContext context, String text, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text),
          content: Text(
            message,
            style: const TextStyle(color: AppColors.red),
          ),
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

  void _showSuccessDialog(BuildContext context, String text, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text),
          content: Text(
            message,
            style: const TextStyle(color: Colors.green),
          ),
          // actions: [
          //   TextButton(
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //       Navigator.pushReplacementNamed(context, AppRoute.home);
          //     },
          //     child: const Text("OK"),
          //   ),
          // ],
        );
      },
    );
  }
}
