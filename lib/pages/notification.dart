import 'dart:convert';
import 'package:code_alpha_campus_event/bankend.dart';
import 'package:code_alpha_campus_event/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Don't forget to import for DateFormat

var baseUrl = Bankend.link;

class Notify extends StatefulWidget {
  const Notify({super.key});

  @override
  State<Notify> createState() => NotifyState();
}

class NotifyState extends State<Notify> {
  @override
  void initState() {
    super.initState();
    getEvent();
  }

  final FlutterSecureStorage storage = FlutterSecureStorage();
  List<dynamic> notify = [];
  bool isSearching = false;
  Map<String, dynamic> profileCache = {}; 
  bool isAccept = false;
  int accept = 0;
  int decline=0; // Cache for profiles

  void startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  void stopSearch() {
    setState(() {
      isSearching = false;
    });
  }

  Future<void> acceptEvent(String eventId) async {
    setState(() {
      isAccept = !isAccept; // Show loading indicator
    });

    final String lik =
        '$baseUrl/events/accept/$eventId'; // Corrected URL if necessary
    print('like endpoint: $lik');

    try {
      String? token = await getToken();
      if (token != null) {
        final response = await http.post(
          Uri.parse(lik),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        print('Response from accepts like API: ${response.body}');

        if (response.statusCode == 200) {
          final decodedResponse = json.decode(response.body);
          print('Decoded response from accepts: $decodedResponse');

          setState(() {
            accept = decodedResponse['data'] ?? 0; 
            decodedResponse['data']==1? _showSuccessDialog(context, 'success', "you have accepted event"):_showSuccessDialog(context, 'success', "you have declined event");
      
     // Update likes count
          });
        } else {
          showErrorDialog(context, "Error", "No accepts data found.");
        }
      } else {
        showErrorDialog(context, "Error", "Token not found. Please log in.");
      }
    } catch (e) {
      showErrorDialog(context, "Error", "Unexpected error: $e");
    }
  }
    Future<void> declineEvent(String eventId) async {
    // setState(() {
    //   isAccept = !isAccept; // Show loading indicator
    // });

    final String lik =
        '$baseUrl/events/decline/$eventId'; // Corrected URL if necessary
    print('like endpoint: $lik');

    try {
      String? token = await getToken();
      if (token != null) {
        final response = await http.post(
          Uri.parse(lik),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        print('Response from decline like API: ${response.body}');

        if (response.statusCode == 200) {
          final decodedResponse = json.decode(response.body);
          print('Decoded response from declines: $decodedResponse');

          setState(() {
            decline = decodedResponse['data'] ?? 0; 
            decodedResponse['data']==1? _showSuccessDialog(context, 'success', "you have delined event"):_showSuccessDialog(context, 'success', "you haven,t declined event");
      
     // Update likes count
          });
        } else {
          showErrorDialog(context, "Error", "No declines data found.");
        }
      } else {
        showErrorDialog(context, "Error", "Token not found. Please log in.");
      }
    } catch (e) {
      showErrorDialog(context, "Error", "Unexpected error: $e");
    }
  }
  

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
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
                
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> getEvent() async {
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

        print("Response status code: ${response.statusCode}");
        print("Response body: ${response.body}");

        if (response.statusCode == 200) {
          final decodedResponse = json.decode(response.body);

          if (decodedResponse != null && decodedResponse.containsKey('notifications')) {
            setState(() {
              notify = decodedResponse['notifications'] ?? [];
            });
          } else {
            print("No notifications found in response.");
            setState(() {
              notify = [];
            });
          }
        } else {
          showErrorDialog(context, "Error", "No notifications found.");
        }
      } else {
        showErrorDialog(context, "Error", "Token not found. Please log in.");
      }
    } catch (e) {
      print("Unexpected error: $e");
      showErrorDialog(context, "Error", "Unexpected error: $e");
    }
  }

  Future<Map<String, dynamic>> getProfile(String? owner) async {
    if (owner == null) {
      // Return a default profile if owner is null
      return {
        'file': 'assets/images/profile.png',
        'name': 'No Owner'
      };
    }

    if (profileCache.containsKey(owner)) {
      return profileCache[owner]; // Return cached profile if available
    }

    try {
      String? token = await getToken();
      if (token != null) {
        final response = await http.get(
          Uri.parse('$baseUrl/profiles/get_profile/$owner'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 200) {
          final profileData = json.decode(response.body)['data'];
          profileCache[owner] = profileData; // Cache the profile
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

  void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  PreferredSizeWidget defaultAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.font2,
      automaticallyImplyLeading: false,
      elevation: 0,
      titleSpacing: 0,
      centerTitle: false,
      title: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 24, bottom: 8, right: 16.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: AppColors.font1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Notification"),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: startSearch,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildSearchAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.font2),
        onPressed: stopSearch,
      ),
      backgroundColor: AppColors.background,
      elevation: 0,
      title: TextField(
        autofocus: true, // Automatically focus on the search bar
        decoration: const InputDecoration(
          hintText: 'Search...',
          hintStyle:
              TextStyle(color: AppColors.font2), // Custom hint text color
          border: InputBorder.none, // Remove default border
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 1.0, color: AppColors.button), // White border
            borderRadius:
                BorderRadius.all(Radius.circular(50)), // Rounded corners
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 1.0, color: AppColors.button), // White border on focus
            borderRadius:
                BorderRadius.all(Radius.circular(50)), // Rounded corners
          ),
          filled: true,
          fillColor: AppColors.button, // Background color of the TextField
        ),
        onChanged: (query) {
          setState(() {
            // Update search query as user types
          });
        },
        style: const TextStyle(color: AppColors.font2), // Custom text color
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSearching ? _buildSearchAppBar() : defaultAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              ...notify.map((notify) {
                return Column(
                  children: [
                    FutureBuilder<Map<String, dynamic>>(
                      future: getProfile(notify['owner']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return BuildNot(
                            image: "assets/images/loading.png", // Loading image
                            title: 'Loading...',
                            eventId: notify['eventId'],
                            acceptEvent: acceptEvent,
                            declineEvent: declineEvent // Pass the method here
                             // Pass the method here
                          );
                        } else if (snapshot.hasError) {
                          return BuildNot(
                            image: "assets/images/profile.png", // Default image on error
                            title: notify['firstName'] ?? 'No name...',
                            eventId: notify['eventId'],
                            acceptEvent: acceptEvent,
                            declineEvent: declineEvent // Pass the method here

                             // Pass the method here
                          );
                        } else {
                          var profile = snapshot.data!;
                          String imageUrl = profile['file'] ?? "assets/images/profile.png";
                          return BuildNot(
                            image: imageUrl,
                            title: "${notify['name'] ?? 'Someone'} has added a new event: ${notify['title'] ?? 'Untitled'}",
                            eventId: notify['eventId'],
                            acceptEvent: acceptEvent,
                            declineEvent: declineEvent // Pass the method here
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget BuildNot({
  required String title,
  required String image,
  String? eventId,
  required Function(String) acceptEvent,
  required Function(String) declineEvent, // Accept the method as a parameter
}) {
  ImageProvider imageProvider;

  // Check if the image is a network URL or an asset
  if (image.startsWith('http')) {
    imageProvider = NetworkImage(image);
  } else {
    imageProvider = AssetImage(image); // Use AssetImage for local assets
  }

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider, // Use the correct ImageProvider
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: AppColors.button,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: AppColors.font2,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: eventId != null
                        ? () {
                            acceptEvent(eventId!);
                             // Call the passed method
                          }
                        : null, // Disable button if eventId is null
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pressedButton,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 2.0),
                    ),
                    child: const Text(
                      "Accept",
                      style: TextStyle(color: AppColors.font2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      declineEvent(eventId!);
                      // Handle delete logic here, if needed
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pressedButton,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 2.0),
                    ),
                    child: const Text(
                      "Decline",
                      style: TextStyle(color: AppColors.font2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
