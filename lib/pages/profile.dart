import 'dart:convert';

import 'package:code_alpha_campus_event/app_styles.dart';
import 'package:code_alpha_campus_event/bankend.dart';
import 'package:code_alpha_campus_event/colors.dart';
import 'package:code_alpha_campus_event/components/event_button.dart';
import 'package:code_alpha_campus_event/config/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var baseUrl = Bankend.link;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override

  void initState() {
    super.initState();
    getProfile();
    getEvent();
    // _filteredEvents;
    doGet(); // Load profile data on initialization
  }

  Map<String, dynamic> data = {};
   List<dynamic>_filteredEvents=[];
  FlutterSecureStorage storage = FlutterSecureStorage();
  String _selectedButton = "All";
  void _handleButtonPress(String buttonText) {
    setState(() {
      _selectedButton = buttonText;
        _filterEvents(); // Update selected button
    });
  }

  List<dynamic> events = [];

  Map<String, dynamic> profile = {};
  void _filterEvents() {
    setState(() {
      if (_selectedButton == "All") {
        // Show all events if "All" is selected
        _filteredEvents = events;
      }
      if (_selectedButton == "Academic") {
        // Show all events if "All" is selected
        _filteredEvents =
            events.where((event) => event['category'] == 'academic').toList();
      }
      if (_selectedButton == "Social") {
        // Show all events if "All" is selected
        _filteredEvents =
            events.where((event) => event['category'] == 'social').toList();
      }
      if (_selectedButton == "Sport") {
        // Show all events if "All" is selected
        _filteredEvents =
            events.where((event) => event['category'] == 'sport').toList();
      }
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
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            width: 1,
            color: AppColors.font1,
          ))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Me",
                style: TextStyle(fontSize: AppStyles.fontsize3),
              ),
              // const SizedBox(width: 15),
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
        value: "logout", // Assign a value to handle the logout option
        child: Text(
          "Logout",
          style: TextStyle(color: AppColors.font2),
        ),
      ),
    ];
  },
  onSelected: (value) async {
    // Handle menu selection
    switch (value) {
      case 'edit_prof':
        Navigator.pushNamed(
          context,
          AppRoute.profile,
        );
        break;
      case 'logout': // Add logout case
        await logout(context); // Call the logout function here
        break;
    }
  },
)

            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 10.0),
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
                      left: 4,
                      bottom: 6,
                     child: TextButton(onPressed: (){
                     _openFilePicker1(context);
                     }, child: Text('add profile',style: TextStyle(color: AppColors.pressedButton),)),
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
                child: SizedBox(
                  width: 200,
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center the Row horizontally
                    children: [
                      FutureBuilder<String?>(
                          future: getUserName(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Text('Error loading user');
                            } else if (!snapshot.hasData) {
                              return const Text('No user'); // Display if no data
                            } else {
                              return Text(
                                snapshot.data!,
                                style: const TextStyle(
                                    color: AppColors.font2,
                                    fontSize: AppStyles.fontsize2),
                              );
                            }
                          }),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.edit,
                        color: Color(0xFF1A73E9), // Icon color
                        size: 20.0,
                      ),
                    ],
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
                          borderRadius: BorderRadius.circular(5))),
                  child: const Text("Edit profile"),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        events.length.toString(),
                        style: const TextStyle(
                            fontSize: AppStyles.fontsize2,
                            color: AppColors.font2),
                      ),
                      SizedBox(height: 10),
                      Text("Events",
                          style: TextStyle(
                              fontSize: AppStyles.fontsize2,
                              color: AppColors.font2)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  EventButton(
                    text: "All",
                    isSelected: _selectedButton == "All",
                    onPressed: () => _handleButtonPress("All"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  EventButton(
                    text: "Academic",
                    isSelected: _selectedButton == "Academic",
                    onPressed: () => _handleButtonPress("Academic"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  EventButton(
                    text: "Social",
                    isSelected: _selectedButton == "Social",
                    onPressed: () => _handleButtonPress("Social"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  EventButton(
                    text: "Sport",
                    isSelected: _selectedButton == "Sport",
                    onPressed: () => _handleButtonPress("Sport"),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 8.0, // Add space between the children horizontally
                runSpacing: 12.0, // Add space between the rows vertically
                children: [
                  if (_filteredEvents.isEmpty)
                   Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.single,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "No events found for this category",
                            style: TextStyle(
                              color: AppColors.pressedButton,
                              fontSize: 18,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoute.home);
                            },
                            child: Text(
                              'View all events',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 22, 106, 216),
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              
                const SizedBox(height: 10),
                  // Use the spread operator to add each event's container directly to the children list
                  ..._filteredEvents.map((event) {
                    return Container(
                      width: 170,
                      height: 180,
                      padding: const EdgeInsets.all(
                          10), // Add padding around the container
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                        color: AppColors
                            .button, // Background color for the container
                        // // Optional: add shadow effect for depth
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(0.2), // Shadow color
                        //     spreadRadius: 2,
                        //     blurRadius: 5,
                        //     offset: Offset(0, 3), // Shadow position
                        //   ),
                        // ],
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align text to the start
                        children: [
                          Text(
                            event['title'] ?? "No title", // Handle null title
                            style: TextStyle(
                              color: AppColors.font1,
                              fontSize:
                                  18, // Increased font size for better readability
                              fontWeight: FontWeight.bold, // Bold font for title
                            ),
                          ),
                          const SizedBox(
                              height:
                                  8), // Spacing between title and first detail
                          Text(
                            "Attended with: ${event['attendes']?.length ?? 0}", // Handle null attended
                            style:
                                TextStyle(color: AppColors.font1, fontSize: 16),
                          ),
                          const SizedBox(height: 4), // Small spacing
                          Text(
                            "Accepted with: ${event['accept']?.length ?? 0}", // Handle null accepted
                            style:
                                TextStyle(color: AppColors.font1, fontSize: 16),
                          ),
                          const SizedBox(height: 4), // Small spacing
                          Text(
                            "Declined with: ${event['decline']?.length ?? 0}", // Handle null declined
                            style:
                                TextStyle(color: AppColors.font1, fontSize: 16),
                          ),
                          const SizedBox(
                              height: 15), // Space before the next element
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> getUserName() async {
    final token = await getToken();

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      return decodedToken['username'];
    } else {
      return null;
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

  Future<void> getEvent() async {
    String? userId = await getUserId();

    try {
      String? token = await getToken();
      if (token != null) {
        final response = await http.get(
          Uri.parse('$baseUrl/events/owner_event/$userId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            // Explicitly cast the events list to List<Map<String, dynamic>>
            events = data['data'] ?? [];
            _filteredEvents=events;
            // _filteredEvents = events;
          });
        } else {
          showErrorDialog(context, "Error", "Failed to load events.");
        }
      } else {
        showErrorDialog(context, "Error", "Token not found. Please log in.");
      }
    } catch (e) {
      showErrorDialog(context, "Error", "Unexpected error: $e");
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

  void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> getUserId() async {
    final token = await getToken();

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      return decodedToken['userId'];
    } else {
      return null;
    }
  }
  Future<void> logout(BuildContext context) async {
  // Example: Clear stored session using SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // Clear stored preferences

  // Navigate to the login screen
  Navigator.pushReplacementNamed(context, AppRoute.login);
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
  Future<void> _openFilePicker1(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    // Pick an image from the gallery
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Call the method to upload the file if an image is selected
      await __registerProfil(image.path);
    } else {
      // Optionally handle the case where no image was selected
      print('No image selected.');
    }
  }

Future<void> __registerProfil(String filePath) async {
    
   
    final url = '$baseUrl/profiles/profile_image';

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    try {
      final response = await request.send();
        print('Profile picture registered  successfully ${response}');


      if (response.statusCode == 200) {
        // Optionally refresh profile data here
        _showSuccessDialog(context, 'success', "Profile picture registered successfully");
        await getProfile(); 
        // Reload profile data after updating
       
      } else {
        print('Failed to update profile picture: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
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
        _showSuccessDialog(context, 'success', "Profile picture updated successfully");
        await getProfile(); 
        // Reload profile data after updating
       
      } else {
        print('Failed to update profile picture: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


}
