import 'dart:convert';
import 'package:code_alpha_campus_event/app_styles.dart';
import 'package:code_alpha_campus_event/bankend.dart';
import 'package:code_alpha_campus_event/colors.dart';
import 'package:code_alpha_campus_event/config/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

var baseUrl = Bankend.link;

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  late String profile = "assets/images/profile.png"; // Default profile image
  Map<String, dynamic> data = {};
  bool isLoading = false;

  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController userName = TextEditingController();

  @override
  void initState() {
    super.initState();
    getProfile();
    // getFirstName();
    doGet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.single,
      appBar: AppBar(
  backgroundColor: AppColors.background,
  foregroundColor: AppColors.font2,
  elevation: 0,
  titleSpacing: 0,
  centerTitle: false,
  title: Row(
    children: [
      Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: profile.startsWith('assets/')
                ? AssetImage(profile)
                : NetworkImage(profile) as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(width: 15),
      // Remove FutureBuilder here
      Text(
        data['firstName'] ?? "No user",
        style: const TextStyle(
            color: AppColors.font2, fontSize: AppStyles.fontsize2),
      ),
    ],
  ),
),

      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                TextField(
                  controller: firstName..text = data['firstName'] ?? '',
                  decoration: InputDecoration(
                    hintText: data['firstName'] ?? "First Name",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    hoverColor: AppColors.font1,
                    fillColor: AppColors.single,
                    prefixIcon: Icon(Icons.person, color: Color(0xFF1A73E9)),
                  ),
                  style: TextStyle(
                    color: AppColors.font2,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: lastName..text = data['lastName'] ?? '',
                  decoration: InputDecoration(
                    hintText: data['lastName'] ?? "Last Name",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    hoverColor: AppColors.font1,
                    fillColor: AppColors.single,
                    prefixIcon: Icon(Icons.person, color: Color(0xFF1A73E9)),
                  ),
                  style: TextStyle(
                    color: AppColors.font2,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: userName..text = data['userName'] ?? '',
                  decoration: InputDecoration(
                    hintText: data['userName'] ?? "UserName",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    hoverColor: AppColors.font1,
                    fillColor: AppColors.single,
                    prefixIcon:
                        Icon(Icons.account_circle, color: Color(0xFF1A73E9)),
                  ),
                  style: TextStyle(
                    color: AppColors.font2,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10.0),
                const TextField(
                  decoration: InputDecoration(
                    hintText: "nzayisengaemmy2001@gmail.com",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    hoverColor: AppColors.font1,
                    fillColor: AppColors.single,
                    prefixIcon: Icon(Icons.email, color: Color(0xFF1A73E9)),
                  ),
                  style: TextStyle(
                    color: AppColors.font2,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                 onPressed: isLoading
                        ? null
                        : () {
                            doUpdate();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.single,
                      side: BorderSide(
                        width: 1,
                        color: AppColors.font1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: AppColors.font2,
                          )
                        : const Text(
                            "Edit",
                            style: TextStyle(color: AppColors.font2),
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  // Future<String?> getFirstName() async {
  //   final token = await getToken();
  //   if (token != null) {
  //     Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
  //     return decodedToken['firstName'];
  //   } else {
  //     return null;
  //   }
  // }

  Future<void> getProfile() async {
    final String? userId = await getuserId();
    try {
      String? token = await getToken();
      if (token != null) {
        final response = await http.get(
          Uri.parse('$baseUrl/profiles/get_profile/$userId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 200) {
          final profileData = json.decode(response.body)['data'];
          setState(() {
            profile = profileData['file'] ?? "assets/images/profile.png";
          });
        } else {
          throw Exception("Profile not found.");
        }
      } else {
        throw Exception("Token not found.");
      }
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  Future<void> doGet() async {
    final token = await getToken();
    String? userId = await getuserId();

    if (token == null || userId == null) {
      throw Exception("Token or User ID not found.");
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/getuser/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final userData = json.decode(response.body)['data'];
        setState(() {
          data = userData ?? {};
        });
      } else {
        throw Exception("User not found. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  Future<String?> getuserId() async {
    final token = await getToken();
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['userId'];
    } else {
      return null;
    }
  }

  Future<void> doUpdate() async {
    String? userId = await getuserId();
    final token = await getToken();

    if (token == null || userId == null) {
      throw Exception("Token or User ID not found.");
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/updateuser/$userId'), // Adjusted endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'firstName': firstName.text,
          'lastName': lastName.text,
          'userName': userName.text,
        }),
      );

      if (response.statusCode == 200) {
        // Handle successful update
        setState(() {
          isLoading = false;
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Profile updated successfully!')),
        // );
        _showSuccessDialog(context, 'profile updated', 'profile updated successfully');
      } else {
        // throw Exception("Failed to update profile.");
        _showSuccessDialog(context, 'failed to update', 'failed to update profile');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception("Unexpected error: $e");
    }
  }
  void _showSuccessDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(
            message,
            style: const TextStyle(color: Colors.green),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, AppRoute.profile);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
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
}
