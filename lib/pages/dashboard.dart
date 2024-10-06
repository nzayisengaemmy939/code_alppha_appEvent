import 'dart:convert';

import 'package:code_alpha_campus_event/app_styles.dart';
import 'package:code_alpha_campus_event/bankend.dart';
import 'package:code_alpha_campus_event/colors.dart';
import 'package:code_alpha_campus_event/components/event_button.dart';
import 'package:code_alpha_campus_event/config/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

var baseUrl = Bankend.link;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  
  void initState() {
    super.initState();
    getProfile();
    getUsers();
    getEvents();
    getNotification();
    getProfiles();
    // getEvent();
    // _filteredEvents;
    doGet(); // Load profile data on initialization
  }

  FlutterSecureStorage storage = FlutterSecureStorage();
  Map<String, dynamic> profile = {};

  String _selectedButton = "Users";
  Map<String, dynamic> data = {};
  Map<String, dynamic> user = {};
// Default selected button
  List<dynamic> users = [];
  List<dynamic> events = [];
  List<dynamic> not = [];
   List<dynamic> profiles = [];
  void _handleButtonPress(String buttonText) {
    setState(() {
      _selectedButton = buttonText; // Update selected button
      // _filterEvents(); // Uncomment if needed later
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.font2,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        title: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: AppColors.font1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Me",
                style: TextStyle(fontSize: AppStyles.fontsize3),
              ),
              Text(
                data['firstName'] ?? "No user",
                style: const TextStyle(fontSize: AppStyles.fontsize3),
              ),
              PopupMenuButton(
                color: AppColors.background,
                elevation: 0,
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      child: Text(
                        "Change Mode",
                        style: TextStyle(color: AppColors.font2),
                      ),
                    ),
                    const PopupMenuItem(
                      value: "edit_prof",
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(color: AppColors.font2),
                      ),
                    ),
                    const PopupMenuItem(
                      value: "logout",
                      child: Text(
                        "Logout",
                        style: TextStyle(color: AppColors.font2),
                      ),
                    ),
                  ];
                },
                onSelected: (value) async {
                  switch (value) {
                    case 'edit_prof':
                      Navigator.pushNamed(
                        context,
                        AppRoute.profile,
                      );
                      break;
                    case 'logout':
                      // Implement your logout function here
                      // await logout(context);
                      break;
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 90.0, // Set width of the image container
                      height: 90.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: profile['file'] != null
                              ? NetworkImage(profile['file'])
                              : AssetImage("assets/images/profile.png"),

                          fit: BoxFit
                              .cover, // Make sure the image covers the circle
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 4,
                      child: GestureDetector(
                        onTap: (){
                           _openFilePicker(context);
                        },
                        child: Icon(
                          Icons.edit,
                          color: Color(0xFF1A73E9), // Icon color
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  '@${data['userName']}',
                  style: const TextStyle(
                    color: AppColors.font2,
                    fontSize: AppStyles.fontsize2,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoute.profile);
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.button,
                    foregroundColor: AppColors.font2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text("Edit profile"),
                ),
              ),
              Row(
                children: [
                  EventButton(
                    text: "Users",
                    isSelected: _selectedButton == "Users",
                    onPressed: () => _handleButtonPress("Users"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  EventButton(
                    text: "Events",
                    isSelected: _selectedButton == "Events",
                    onPressed: () => _handleButtonPress("Events"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  EventButton(
                    text: "Notification",
                    isSelected: _selectedButton == "Notification",
                    onPressed: () => _handleButtonPress("Notification"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  EventButton(
                    text: "Profiles",
                    isSelected: _selectedButton == "Profiles",
                    onPressed: () => _handleButtonPress("Profiles"),
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection:
                    Axis.horizontal, // Enables horizontal scrolling
                child: Column(
                  children: [
                    if (_selectedButton == 'Users')
                      Table(
                        defaultColumnWidth: FixedColumnWidth(130.0),
                        columnWidths: const {
                          0: FixedColumnWidth(
                              100.0), // Set width for the first column
                          1: FixedColumnWidth(
                              100.0), // Set width for the second column
                          2: FixedColumnWidth(100.0),

                          3: FixedColumnWidth(200.0),
                          4: FixedColumnWidth(70.0),
                          5: FixedColumnWidth(100.0),
                          6: FixedColumnWidth(100.0),
                          // 7: FixedColumnWidth(90.0),
                          //  8: FixedColumnWidth(140.0),
                        },
                        children: [
                          const TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('FirstName',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('SecondName',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Email',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('_id',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Role',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Actions',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Change role',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                            ],
                          ),
                          // Dynamically add user data rows
                          ...users.map((user) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(user['firstName'] ?? '',
                                      style: TextStyle(color: AppColors.font2)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(user['lastName'] ?? '',
                                      style: TextStyle(color: AppColors.font2)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(user['email'] ?? '',
                                      style: TextStyle(color: AppColors.font2)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(user['_id'] ?? '',
                                      style: TextStyle(color: AppColors.font2)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(user['role'] ?? '',
                                      style: TextStyle(color: AppColors.font2)),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    showConfirmationDialog(
                                      context,
                                      () async {
                                        bool isDeleted =
                                            await deleteUser(user['_id']);
                                        if (isDeleted) {
                                          _showSuccessDialog(context, 'Success',
                                              'User deleted successfully');
                                          setState(() {
                                            // user = {}; // Clear user data if needed
                                            // getUsers();
                                            // // Fetch the updated list of users
                                            Navigator.pushNamed(
                                                context, AppRoute.dash);
                                          });
                                        }
                                      },
                                    );
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: AppColors.font2),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 2.0),
                                    backgroundColor: const Color.fromRGBO(
                                        174, 59, 51, 1), // Background color
                                    side: const BorderSide(
                                        width: 1), // Optional border
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Rounded corners
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Your delete action here
                                  },
                                  child: const Text(
                                    'change role',
                                    style: TextStyle(color: AppColors.font2),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0, vertical: 2.0),

                                    backgroundColor: AppColors
                                        .pressedButton, // Set background color to red
                                    side: BorderSide(
                                        width:
                                            1), // Optional: Add border if needed
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Rounded rectangle shape
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    if (_selectedButton == 'Notification')
                      Table(
                        defaultColumnWidth: const FixedColumnWidth(130.0),
                       columnWidths: const {
                          0: FixedColumnWidth(
                              100.0), // Set width for the first column
                          1: FixedColumnWidth(
                              100.0), // Set width for the second column
                          2: FixedColumnWidth(100.0),

                          3: FixedColumnWidth(100.0),
                          4: FixedColumnWidth(150.0),
                          5: FixedColumnWidth(100.0),
                          // 6: FixedColumnWidth(100.0),
                          // 7: FixedColumnWidth(90.0),
                          //  8: FixedColumnWidth(140.0),
                        },
                        children: [
                          const TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("ID",
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('userId',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('owner',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Title',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Date',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Actions',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                            ],
                          ),
                          // Dynamically add event data rows
                          ...not.map((not1) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(not1['_id'] ?? '',
                                      style: TextStyle(color: AppColors.font2)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(not1['userId'] ?? '',
                                      style: TextStyle(color: AppColors.font2)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(not1['owner'] ?? '',
                                      style: TextStyle(color: AppColors.font2)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(not1['title'] ?? '',
                                      style: TextStyle(color: AppColors.font2)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(not1['createdAt'] ?? '',
                                      style: TextStyle(color: AppColors.font2)),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    showConfirmationDialog(
                                      context,
                                      () async {
                                        bool isDeleted = await deleteNot(not1['_id']);
                                        if (isDeleted) {
                                          _showSuccessDialog(context, 'Success', 'Event deleted successfully');
                                        
                                            // Fetch the updated list of events
                                            Navigator.pushNamed(context, AppRoute.dash);
                                          
                                        };
                                      },
                                    );
                                  },
                                  child: const Text('Delete',
                                      style: TextStyle(color: AppColors.font2)),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 2.0),
                                    backgroundColor: const Color.fromRGBO(
                                        174, 59, 51, 1), // Background color
                                    side: const BorderSide(
                                        width: 1), // Optional border
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Rounded corners
                                    ),
                                  ),
                                ),
                               
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    if (_selectedButton == 'Events')
                      Table(
                        defaultColumnWidth: const FixedColumnWidth(130.0),
                        columnWidths: const {
                          0: FixedColumnWidth(
                              100.0), // Set width for the first column
                          1: FixedColumnWidth(
                              100.0), // Set width for the second column
                          2: FixedColumnWidth(100.0),

                          3: FixedColumnWidth(200.0),
                          4: FixedColumnWidth(300.0),
                          5: FixedColumnWidth(100.0),
                          6: FixedColumnWidth(100.0),
                          7: FixedColumnWidth(90.0),
                           8: FixedColumnWidth(140.0),
                        },
                        children: [
                          const TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("ID",
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Owner',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Name',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Title',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Description',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Date',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Category',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Actions',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Change category',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                            ],
                          ),
                          // Dynamically add event data rows
                          ...events.map((event) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(event['_id'] ?? '',
                                      style: TextStyle(color: AppColors.font2)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(event['owner'] ?? '',
                                      style: TextStyle(color: AppColors.font2)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(event['name'] ?? '',
                                      style: TextStyle(color: AppColors.font2)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(event['title'] ?? '',
                                      style: TextStyle(color: AppColors.font2)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(event['description'] ?? '',
                                      style: TextStyle(color: AppColors.font2)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(event['date'] ?? '',
                                      style: TextStyle(color: AppColors.font2)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(event['category'] ?? '',
                                      style: TextStyle(color: AppColors.font2)),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    showConfirmationDialog(
                                      context,
                                      () async {
                                        bool isDeleted = await deleteIvent(event['_id']);
                                        if (isDeleted) {
                                          _showSuccessDialog(context, 'Success', 'Event deleted successfully');
                                          setState(() {
                                            // Fetch the updated list of events
                                           Navigator.pushNamed(context, AppRoute.dash);
                                          });
                                        }
                                      },
                                    );
                                  },
                                  child: const Text('Delete',
                                      style: TextStyle(color: AppColors.font2)),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    backgroundColor: const Color.fromRGBO(
                                        174, 59, 51, 1), // Background color
                                    side: const BorderSide(
                                        width: 1), // Optional border
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Rounded corners
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Your change role action here
                                  },
                                  child: const Text('change Category',
                                      style: TextStyle(color: AppColors.font2)),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0, vertical: 2.0),
                                    backgroundColor: AppColors.pressedButton,
                                    side: const BorderSide(
                                        width:
                                            1), // Optional: Add border if needed
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Rounded rectangle shape
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                      if (_selectedButton == 'Profiles')
                      Table(
                        defaultColumnWidth: const FixedColumnWidth(130.0),
                       columnWidths: const {
                          0: FixedColumnWidth(
                              100.0), // Set width for the first column
                          1: FixedColumnWidth(
                              100.0), // Set width for the second column
                          2: FixedColumnWidth(400.0),

                         
                        },
                        children: [
                          const TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("ID",
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                             
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('owner',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                              
                             Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('file',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Actions',
                                    style: TextStyle(color: AppColors.font2)),
                              ),
                            ],
                          ),
                          // Dynamically add event data rows
                          ...profiles.map((prof) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(prof['_id'] ?? '',
                                      style: TextStyle(color: AppColors.font2)),
                                ),
                               
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(prof['owner'] ?? '',
                                      style: TextStyle(color: AppColors.font2)),
                                ),
                              
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(prof['file'] ?? '',
                                      style: TextStyle(color: AppColors.font2)),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // showConfirmationDialog(
                                    //   context,
                                    //   () async {
                                    //     bool isDeleted = await deleteEvent(event['_id']);
                                    //     if (isDeleted) {
                                    //       _showSuccessDialog(context, 'Success', 'Event deleted successfully');
                                    //       setState(() {
                                    //         // Fetch the updated list of events
                                    //         getEvents();
                                    //       });
                                    //     }
                                    //   },
                                    // );
                                  },
                                  child: const Text('Delete',
                                      style: TextStyle(color: AppColors.font2)),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 2.0),
                                    backgroundColor: const Color.fromRGBO(
                                        174, 59, 51, 1), // Background color
                                    side: const BorderSide(
                                        width: 1), // Optional border
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Rounded corners
                                    ),
                                  ),
                                ),
                               
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
Future<void> _openFilePicker(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    // Pick an image from the gallery
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Call the method to upload the file if an image is selected
      await _uploadFile(image.path);
    } else {
      // Optionally handle the case where no image was selected
      print('No image selected.');
    }
  }

  // Method to upload the file to the backend
  
  Future<void> _uploadFile(String filePath) async {
    String ?ownerId=profile['owner'];
    print("ownerId |$ownerId");
    final url = '$baseUrl/profiles/edit_profile/$ownerId';

    var request = http.MultipartRequest('PUT', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        print('Profile picture updated successfully');
        // Optionally refresh profile data here
        await getProfile(); // Reload profile data after updating
      } else {
        print('Failed to update profile picture: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
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
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.pushReplacementNamed(context, AppRoute.home);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void showConfirmationDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Event'),
          content: const Text('Do you want to delete this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onConfirm(); // Call the confirmation action
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> deleteUser(String id) async {
    try {
      String? token = await getToken();
      if (token != null) {
        final response = await http.delete(
          Uri.parse('$baseUrl/users/delete/$id'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final decodedResponse = json.decode(response.body);
          print('User deleted: ${decodedResponse['data']}');
          return true; // Deletion was successful
        } else {
          _showErrorDialog(context, "Error", "No user found.");
          return false; // Deletion failed
        }
      } else {
        _showErrorDialog(context, "Error", "Token not found. Please log in.");
        return false; // Deletion failed
      }
    } catch (e) {
      _showErrorDialog(context, "Error", "Unexpected error: $e");
      return false; // Deletion failed
    }
  }
    Future<bool> deleteIvent(String id) async {
    try {
      String? token = await getToken();
      if (token != null) {
        final response = await http.delete(
          Uri.parse('$baseUrl/events/delete_event/$id'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final decodedResponse = json.decode(response.body);
          print('Event deleted: ${decodedResponse['data']}');
          return true; // Deletion was successful
        } else {
          _showErrorDialog(context, "Error", "No events found.");
          return false; // Deletion failed
        }
      } else {
        _showErrorDialog(context, "Error", "Token not found. Please log in.");
        return false; // Deletion failed
      }
    } catch (e) {
      _showErrorDialog(context, "Error", "error:failed to access to db ");
      return false; // Deletion failed
    }
  }
Future<bool> deleteNot(String id) async {
    try {
      String? token = await getToken();
      if (token != null) {
        final response = await http.delete(
          Uri.parse('$baseUrl/notifications/delete/$id'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final decodedResponse = json.decode(response.body);
          print('Event deleted: ${decodedResponse['data']}');
          return true; // Deletion was successful
        } else {
          _showErrorDialog(context, "Error", "No notifications found.");
          return false; // Deletion failed
        }
      } else {
        _showErrorDialog(context, "Error", "Token not found. Please log in.");
        return false; // Deletion failed
      }
    } catch (e) {
      _showErrorDialog(context, "Error", "error:failed to access to db ");
      return false; // Deletion failed
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
      print('reponsegeggeggeg ${response.body}');
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

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
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
        print('response body==== ${response.body}');
        print('response statusCode==== ${response.statusCode}');
        print('userId==== $userId');

        if (response.statusCode == 200) {
          final profileData = json.decode(response.body)['data'];

          profile = profileData; // Cache the profile
          return profileData;
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
Future<void> getProfiles() async {
    final String? userId = await getuserId();
    try {
      String? token = await getToken();
      if (token != null) {
        final response = await http.get(
          Uri.parse('$baseUrl/profiles/get_profiles'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
     
        print('response statusCode==== ${response.statusCode}');
     

        if (response.statusCode == 200) {
          final profileData = json.decode(response.body)['data'];

          profiles = profileData; // Cache the profile
          return profileData;
        } else {
          throw Exception("Profiles not found.");
        }
      } else {
        throw Exception("Token not found.");
      }
    } catch (e) {
      throw Exception("Unexpected error: failed to access to db");
    }
  }
  Future<void> getUsers() async {
    try {
      String? token = await getToken();
      if (token != null) {
        final response = await http.get(
          Uri.parse('$baseUrl/users/getusers'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 200) {
          final decodedResponse = json.decode(response.body);
          print('get usersrs from backend ${decodedResponse['data']}');
          setState(() {
            users = decodedResponse['data'] ?? [];
            // _filteredEvents = _events; // Initially display all events
          });
        } else {
          _showErrorDialog(context, "Error", "No users found.");
        }
      } else {
        _showErrorDialog(context, "Error", "Token not found. Please log in.");
      }
    } catch (e) {
      _showErrorDialog(context, "Error", "Unexpected error: $e");
    }
  }

  Future<void> getEvents() async {
    try {
      String? token = await getToken();
      if (token != null) {
        final response = await http.get(
          Uri.parse('$baseUrl/events/get_events'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 200) {
          final decodedResponse = json.decode(response.body);
          print(
              'get eventstststtsttst from backend ${decodedResponse['data']}');
          setState(() {
            events = decodedResponse['data'] ?? [];
            // _filteredEvents = _events; // Initially display all events
          });
        } else {
          _showErrorDialog(context, "Error", "No events found.");
        }
      } else {
        _showErrorDialog(context, "Error", "Token not found. Please log in.");
      }
    } catch (e) {
      _showErrorDialog(context, "Error", "Unexpected error: $e");
    }
  }

  Future<void> getNotification() async {
    try {
      String? token = await getToken();
      if (token != null) {
        final response = await http.get(
          Uri.parse('$baseUrl/notifications/notification'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 200) {
          final decodedResponse = json.decode(response.body);
          print('get notificationscheckxxxxx from backend $decodedResponse');
          setState(() {
            not = decodedResponse['notifications'] ?? [];
            // _filteredEvents = _events; // Initially display all events
          });
        } else {
          _showErrorDialog(context, "Error", "No notification found.");
        }
      } else {
        _showErrorDialog(context, "Error", "Token not found. Please log in.");
      }
    } catch (e) {
      _showErrorDialog(context, "Error", "error: failed to access to database");
    }
  }

  void _showErrorDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
