import 'dart:async';
import 'dart:convert';

import 'package:code_alpha_campus_event/app_styles.dart';
import 'package:code_alpha_campus_event/bankend.dart';
import 'package:code_alpha_campus_event/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Single extends StatefulWidget {
  const Single({super.key});

  @override
  State<Single> createState() => _SingleState();
}

class _SingleState extends State<Single> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  Map<String, dynamic> event = {}; // Store the event details
  late String eventId;
  late String name;
  late String image;

  int likes = 0;
  int dislikes = 0;
  int  attended=0;
  bool active = false;
   bool isAttended=false;
   bool isDisliked=false;
  
  @override
  void initState() {
    super.initState();
    // Fetch arguments right in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      eventId = arguments['eventId'];
      name = arguments['name'];
      image = arguments['image'];

      getEvent(); // Fetch event details
      getLikes();
      getDislikes();
      attendEvennt(); // Fetch likes count
    });
  }

  @override
  Widget build(BuildContext context) {
    // Parse and format the event date
    String eventDate = event['date'] ?? ''; // Default to empty if null
    String formattedDate = '';

    if (eventDate.isNotEmpty) {
      DateTime parsedDate = DateTime.parse(eventDate);
      formattedDate = DateFormat('MMMM d, yyyy')
          .format(parsedDate); // e.g., "September 26, 2024"
    }

    return Scaffold(
      backgroundColor: AppColors.single,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 16, 32, 70),
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
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Text(name ?? "loading..."),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Title
                Text(
                  event['title'] ?? "Event Title...", // Default title
                  style: TextStyle(
                    fontSize: AppStyles.fontsize2,
                    fontWeight: FontWeight.bold,
                    color: AppColors.font2,
                  ),
                ),
                const SizedBox(height: 10.0),

                // Event Description
                Text(
                  event['description'] ??
                      "Event Description...", // Default description
                  style: TextStyle(
                    fontSize: AppStyles.fontsize3,
                    color: AppColors.font1,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20.0),

                // Event Date and Time
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: AppColors.pressedButton),
                    const SizedBox(width: 10),
                    Text(
                      "Date: ${formattedDate.isNotEmpty ? formattedDate : 'N/A'}",
                      style: const TextStyle(
                        fontSize: AppStyles.fontsize3,
                        color: AppColors.font1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),

                Row(
                  children: [
                    const Icon(Icons.access_time,
                        color: AppColors.pressedButton),
                    const SizedBox(width: 10),
                    Text(
                      "Time: ${event['time'] ?? 'N/A'}", // Use event data
                      style: const TextStyle(
                        fontSize: AppStyles.fontsize3,
                        color: AppColors.font1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),

                // Event Location
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: AppColors.pressedButton),
                    const SizedBox(width: 10),
                    Text(
                      "Location: ${event['location'] ?? 'N/A'}", // Use event data
                      style: const TextStyle(
                        fontSize: AppStyles.fontsize3,
                        color: AppColors.font1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),

                // Event Status
                Row(
                  children: [
                    const Text("Status: ",
                        style: TextStyle(color: AppColors.font2)),
                    Text(
                      event['status'] ??
                          'Unknown', // Default to 'Unknown' if null
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),

                // Call to Action Buttons
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        getLikes();
                        // Refresh the likes count when button is clicked
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.button,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13.0, vertical: 2.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            likes.toString(), // Convert int likes to String
                            style: const TextStyle(
                                color: AppColors.font2,
                                fontSize: AppStyles.fontsize3),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: active
                                ? AppColors.font2
                                : AppColors
                                    .pressedButton, // Use isLiked to manage color
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Thumbs Down Button (currently static)
                    ElevatedButton(
                      onPressed: () {
                        getDislikes();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.button,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13.0, vertical: 2.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(dislikes.toString(), // Static for now
                              style: const TextStyle(
                                  color: AppColors.font2,
                                  fontSize: AppStyles.fontsize3)),
                          const SizedBox(width: 10),
                          Icon(Icons.thumb_down_alt_outlined,
                              color:isDisliked
                                ? AppColors.pressedButton
                                : AppColors
                                    .font2,),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        attendEvennt();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 2.0),
                        backgroundColor: AppColors.pressedButton,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      child: Text(
                        isAttended?"attend Event":"attended",
                        style: const TextStyle(
                            fontSize: AppStyles.fontsize3, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final baseUrl = Bankend.link;

  Future<void> getEvent() async {
    try {
      String? token = await getToken();
      if (token != null) {
        final response = await http.get(
          Uri.parse(
              '$baseUrl/events/get_event/$eventId'), // Corrected URL endpoint
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 200) {
          final decodedResponse = json.decode(response.body);
          setState(() {
            event = decodedResponse['data'] ?? {}; // Assign the event data
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

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
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

  bool isLiked = false; // To track whether the user has liked the event

  Future<void> getLikes() async {
    print('event_id: $eventId');
    setState(() {
      active = !active; // Show loading indicator
    });

    final String lik =
        '$baseUrl/events/likes/$eventId'; // Corrected URL if necessary
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

        print('Response from get likes API: ${response.body}');

        if (response.statusCode == 200) {
          final decodedResponse = json.decode(response.body);
          print('Decoded response: $decodedResponse');

          setState(() {
            likes = decodedResponse['data'] ?? 0; // Update likes count
           // Mark as liked
          });
        } else {
          _showErrorDialog(context, "Error", "No likes data found.");
       
        }
      } else {
        _showErrorDialog(context, "Error", "Token not found. Please log in.");
      
      }
    } catch (e) {
      _showErrorDialog(context, "Error", "Unexpected error: $e");
     
    }
  }

  Future<void> getDislikes() async {
     setState(() {
    isDisliked = !isDisliked; // Toggle the state between true and false
  });
    try {
      String? token = await getToken(); // Await the token
      if (token != null) {
        final response = await http.post(
          Uri.parse('$baseUrl/events/dislikes/$eventId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token', // Fixed typo
          },
        );

        print('Response from get dislikes API: ${response.body}');

        if (response.statusCode == 200) {
          final decodedResponse = json.decode(response.body);
          print('Decoded response from dislikes API: $decodedResponse');

          setState(() {
            dislikes =
                decodedResponse['data'] ?? 0; // Assign the number of dislikes
          });
        } else {
          _showErrorDialog(context, "Error", "No dislikes data found.");
        }
      } else {
        _showErrorDialog(context, "Error", "Token not found. Please log in.");
      }
    } catch (e) {
      _showErrorDialog(context, "Error", "Unexpected error: $e");
    }
  }

  Future<void> attendEvennt() async {
   setState(() {
    isAttended = !isAttended; // Toggle the state between true and false
  });
    try {
      String? token = await getToken(); // Await the token
      if (token != null) {
        final response = await http.post(
          Uri.parse('$baseUrl/events/attend_events/$eventId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token', // Fixed typo
          },
        );

        print('Response from get attend_events API: ${response.body}');

        if (response.statusCode == 200) {
          final decodedResponse = json.decode(response.body);
          print('Decoded response from attend_events API: $decodedResponse');

          setState(() {
            attended =
                decodedResponse['data']?? 0; // Assign the number of dislikes
          });
        } else {
          _showErrorDialog(context, "Error", "No attend_events data found.");
        }
      } else {
        _showErrorDialog(context, "Error", "Token not found. Please log in.");
      }
    } catch (e) {
      _showErrorDialog(context, "Error", "Unexpected error: $e");
    }
  }
}
