import 'dart:convert';
import 'package:code_alpha_campus_event/bankend.dart';
import 'package:code_alpha_campus_event/colors.dart';
import 'package:code_alpha_campus_event/components/app_bar.dart';
import 'package:code_alpha_campus_event/components/app_event.dart';
import 'package:code_alpha_campus_event/components/event_button.dart';
import 'package:code_alpha_campus_event/config/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _selectedButton = "All"; // Default selected button
  bool _isSearching = false;
  List<dynamic> _events = []; // List to hold events
  List<dynamic> _filteredEvents = []; // To hold filtered events
  Map<String, dynamic> profileCache = {}; // Cache profiles by owner
  final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    getEvents(); // Fetch events on initial load
  }

  // Base URL for API
  String get baseUrl => Bankend.link;

  // Handle button press for filtering events
  void _handleButtonPress(String buttonText) {
    setState(() {
      _selectedButton = buttonText; // Update selected button
      _filterEvents(); // Call the event filtering function
    });
  }

  // Filter events by category
  void _filterEvents() {
    setState(() {
      if (_selectedButton == "All") {
        // Show all events if "All" is selected
        _filteredEvents = _events;
      }
      if (_selectedButton == "Academic") {
        // Show all events if "All" is selected
        _filteredEvents =
            _events.where((event) => event['category'] == 'academic').toList();
      }
      if (_selectedButton == "Social") {
        // Show all events if "All" is selected
        _filteredEvents =
            _events.where((event) => event['category'] == 'social').toList();
      }
      if (_selectedButton == "Sport") {
        // Show all events if "All" is selected
        _filteredEvents =
            _events.where((event) => event['category'] == 'sport').toList();
      }
    });
  }

  // Toggle search mode
  void _startSearch() {
    setState(() {
      _isSearching = true; // Show the search bar
    });
  }

  // End search mode
  void _stopSearch() {
    setState(() {
      _isSearching = false; // Hide the search bar
    });
  }

  // Build the search app bar
  PreferredSizeWidget _buildSearchAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.font2),
        onPressed: _stopSearch, // Go back to the default app bar
      ),
      backgroundColor: AppColors.background,
      elevation: 0,
      title: TextField(
        autofocus: true, // Automatically focus on the search bar
        decoration: const InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: AppColors.font2),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: AppColors.button),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: AppColors.button),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          filled: true,
          fillColor: AppColors.button,
        ),
        onChanged: (query) {
          setState(() {
            // Update search query as user types
          });
        },
        style: const TextStyle(color: AppColors.font2),
      ),
    );
  }

  // Build the default app bar with a search icon and popup menu
  PreferredSizeWidget _buildDefaultAppBar() {
    return CustomAppBar(
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _startSearch,
        ),
        PopupMenuButton<String>(
          color: AppColors.background,
          onSelected: (value) {
            // Handle menu selection
            switch (value) {
              case 'update':
                Navigator.pushNamed(context, AppRoute.campusUpdate);
                break;
              case 'link':
                Navigator.pushNamed(context, AppRoute.link);
                break;
            }
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem<String>(
                value: 'update',
                child: Row(
                  children: [
                    Icon(Icons.update, color: AppColors.font2),
                    SizedBox(width: 8),
                    Text('Campus Update',
                        style: TextStyle(color: AppColors.font1)),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'link',
                child: Row(
                  children: [
                    Icon(Icons.link, color: AppColors.font2),
                    SizedBox(width: 8),
                    Text('Quick Links',
                        style: TextStyle(color: AppColors.font1)),
                  ],
                ),
              ),
            ];
          },
          icon: const Icon(Icons.more_vert, color: AppColors.font2),
        ),
      ],
      name: "Incoming Events",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearching ? _buildSearchAppBar() : _buildDefaultAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildCategoryButtons(),
              const SizedBox(height: 10),
              // Handle empty event list case
              if (_filteredEvents.isEmpty)
                const Text(
                  "No events found for this category",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              const SizedBox(height: 10),
              ..._filteredEvents.map((event) {
                DateTime createdAt = DateTime.parse(event['createdAt']);
                String formattedTime = DateFormat.jm().format(createdAt);

                return Column(
                  children: [
                    FutureBuilder<Map<String, dynamic>>(
                      future: getProfile(event['owner']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return AppEvent(
                            eventId: "loading",
                            image: "assets/images/loading.png", // Loading image
                            name: "Loading...",
                            title: event['title'],
                            created: formattedTime,
                          );
                        } else if (snapshot.hasError ||
                            !snapshot.hasData ||
                            snapshot.data!['file'] == null) {
                          return AppEvent(
                            eventId: event['_id'],
                            image:
                                "assets/images/profile.png", // Default image on error or missing profile
                            name: event['name'] ?? "No Owner",
                            title: event['title'],
                            created: formattedTime,
                          );
                        } else {
                          var profile = snapshot.data!;
                          String imageUrl =
                              profile['file'] ?? "assets/images/profile.png";

                          return AppEvent(
                            eventId: event['_id'],
                            image: imageUrl,
                            name: event['name'] ?? "No Owner",
                            title: event['title'],
                            created: formattedTime,
                          );
                        }
                      },
                    ),

                    const SizedBox(
                        height: 15), // Space of 20 pixels after each event
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Row(
      children: [
        EventButton(
          text: "All",
          isSelected: _selectedButton == "All",
          onPressed: () => _handleButtonPress("All"),
        ),
        const SizedBox(width: 10),
        EventButton(
          text: "Academic",
          isSelected: _selectedButton == "Academic",
          onPressed: () => _handleButtonPress("Academic"),
        ),
        const SizedBox(width: 10),
        EventButton(
          text: "Social",
          isSelected: _selectedButton == "Social",
          onPressed: () => _handleButtonPress("Social"),
        ),
        const SizedBox(width: 10),
        EventButton(
          text: "Sport",
          isSelected: _selectedButton == "Sport",
          onPressed: () => _handleButtonPress("Sport"),
        ),
      ],
    );
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
          setState(() {
            _events = decodedResponse['data'] ?? [];
            _filteredEvents = _events; // Initially display all events
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

  Future<Map<String, dynamic>> getProfile(String? owner) async {
    if (owner == null) {
      // Return a default profile if owner is null
      return {'file': 'assets/images/profile.png', 'name': 'No Owner'};
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
        print('response body====222 ${response.body}');
        print('response body====111 ${response.statusCode}');
          print('response body====111 $owner');

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

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
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
