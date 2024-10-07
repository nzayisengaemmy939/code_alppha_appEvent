import 'package:code_alpha_campus_event/bankend.dart';
import 'package:code_alpha_campus_event/colors.dart';
import 'package:code_alpha_campus_event/config/app_route.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var baseUrl = Bankend.link;

class Register extends StatefulWidget {
  Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var firstName = "";
  var lastName = "";
  var email = "";
  var userName = "";
  var password = "";
  var confirmPassword = "";
  var text="";
  bool isLoading = false; // Track loading state

  final String registerUrl = '$baseUrl/users/register';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.single,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.font2,
        title: const Text("Register"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                _buildTextField("First Name", Icons.person, (value) {
                  setState(() {
                    firstName = value;
                  });
                }),
                const SizedBox(height: 10),
                _buildTextField("Last Name", Icons.person, (value) {
                  setState(() {
                    lastName = value;
                  });
                }),
                const SizedBox(height: 10),
                _buildTextField("Username", Icons.lock, (value) {
                  setState(() {
                    userName = value;
                  });
                }),
                const SizedBox(height: 10),
                _buildTextField("Email", Icons.email, (value) {
                  setState(() {
                    email = value;
                  });
                }),
                const SizedBox(height: 10),
                _buildTextField("Password", Icons.lock, (value) {
                  setState(() {
                    password = value;
                  });
                }, isPassword: true),
                const SizedBox(height: 10),
                _buildTextField("Confirm Password", Icons.lock, (value) {
                  setState(() {
                    confirmPassword = value;
                  });
                }, isPassword: true),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (password == confirmPassword) {
                        if (!isLoading) {
                          doRegister(
                              userName, firstName, lastName, password, email);
                        }
                      } else {
                        _showErrorDialog(context,"Error", "Passwords do not match!");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pressedButton,
                      side: const BorderSide(width: 1, color: AppColors.font1),
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
                            "Register",
                            style: TextStyle(color: AppColors.font2),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String hintText, IconData icon, Function(String) onChanged,
      {bool isPassword = false}) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.font2),
        border: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: AppColors.red),
        ),
        filled: true,
        hoverColor: AppColors.font1,
        fillColor: AppColors.single,
        prefixIcon: Icon(icon, color: const Color(0xFF1A73E9)),
      ),
      style: const TextStyle(
        color: AppColors.font2,
        fontSize: 16,
      ),
      obscureText: isPassword,
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

Future<void> doRegister(String userName, String firstName, String lastName, String password, String email) async {
  setState(() {
    isLoading = true;
  });

  final response = await http.post(
    Uri.parse(registerUrl),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'userName': userName,
      'lastName': lastName,
      'firstName': firstName,
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
    try {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        _showSuccessDialog(context, "Success", data['message']);
          Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, AppRoute.login);
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
      _showErrorDialog(context, "Error", "failed to access to database");
    }
  }
}




}
