import 'dart:convert';

import 'package:code_alpha_campus_event/bankend.dart';
import 'package:code_alpha_campus_event/colors.dart';
import 'package:code_alpha_campus_event/config/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

var baseUrl = Bankend.link;

class Edit extends StatefulWidget {
  const Edit({super.key});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  String? argumentsId;
  bool isLoading = false;
  String? selectedCategory;
  List<String> item = ["Category 1", "Category 2", "Category 3"];

  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationLinkController = TextEditingController();
  final TextEditingController _locationNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch arguments in didChangeDependencies instead of initState
    argumentsId = ModalRoute.of(context)!.settings.arguments as String?;
  }

  Future<void> doUpdate() async {
    final token = await getToken();

    final role = await getRole();
    if (selectedCategory == "academic" && role != 'admin') {
      _showErrorDialog(context, "Error",
          "You are not allowed to submit academic events becouse you are not admin.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await http.put(
      Uri.parse('$baseUrl/events/update_event/$argumentsId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'category': selectedCategory,
        'date': _dateController.text,
        'time': _timeController.text,
        'locationLink': _locationLinkController.text,
        'locationName': _locationNameController.text,
      }),
    );

    setState(() {
      isLoading = false;
    });

    print('Response status: ${response.statusCode}');
    print('arumentssss: ${argumentsId}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          _showSuccessDialog(context, "Success", data['message']);
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, AppRoute.event);
          });
        } else {
          _showErrorDialog(context, "Error", data['message']);
        }
      } catch (e) {
        _showErrorDialog(context, "Error", "Error parsing response: $e");
      }
    } else {
      try {
        final data = jsonDecode(response.body);
        _showErrorDialog(context, "Error", data["message"]);
      } catch (e) {
        _showErrorDialog(context, "Error", "Unexpected error: $e");
      }
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
                Navigator.pushNamed(context, AppRoute.event);
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.single,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.font2,
        title: const Text("Edit Event"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: "Title",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    fillColor: AppColors.single,
                    prefixIcon: Icon(Icons.title, color: Color(0xFF1A73E9)),
                  ),
                  style: const TextStyle(color: AppColors.font2, fontSize: 16),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: "Description",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    fillColor: AppColors.single,
                    prefixIcon:
                        Icon(Icons.description, color: Color(0xFF1A73E9)),
                  ),
                  style: const TextStyle(color: AppColors.font2, fontSize: 16),
                ),
                const SizedBox(height: 10.0),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.single,
                    border: Border.all(color: AppColors.font1, width: 1),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: const Text("Category",
                          style: TextStyle(color: AppColors.font2)),
                      value: selectedCategory,
                      onChanged: (String? value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                      items: item.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: const TextStyle(color: AppColors.font1)),
                        );
                      }).toList(),
                      icon: const Icon(Icons.arrow_drop_down,
                          color: AppColors.font1),
                      dropdownColor: AppColors.single,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: const InputDecoration(
                    hintText: "Date",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    fillColor: AppColors.single,
                    prefixIcon:
                        Icon(Icons.date_range, color: Color(0xFF1A73E9)),
                  ),
                  style: const TextStyle(color: AppColors.font2, fontSize: 16),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _timeController,
                  readOnly: true,
                  onTap: () => _selectTime(context),
                  decoration: const InputDecoration(
                    hintText: "Time",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    fillColor: AppColors.single,
                    prefixIcon:
                        Icon(Icons.access_time, color: Color(0xFF1A73E9)),
                  ),
                  style: const TextStyle(color: AppColors.font2, fontSize: 16),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _locationLinkController,
                  decoration: const InputDecoration(
                    hintText: "Location Link",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    fillColor: AppColors.single,
                    prefixIcon: Icon(Icons.link, color: Color(0xFF1A73E9)),
                  ),
                  style: const TextStyle(color: AppColors.font2, fontSize: 16),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _locationNameController,
                  decoration: const InputDecoration(
                    hintText: "Location Name",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    fillColor: AppColors.single,
                    prefixIcon:
                        Icon(Icons.location_on, color: Color(0xFF1A73E9)),
                  ),
                  style: const TextStyle(color: AppColors.font2, fontSize: 16),
                ),
                const SizedBox(height: 20.0),
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
                      side: const BorderSide(width: 1, color: AppColors.font1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: AppColors.font2)
                        : const Text(
                            "Send",
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

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<String?> getRole() async {
    final token = await getToken();

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      return decodedToken['role'];
    } else {
      return null;
    }
  }
}
