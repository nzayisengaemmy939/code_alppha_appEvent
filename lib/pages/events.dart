import 'dart:convert';

import 'package:code_alpha_campus_event/bankend.dart';
import 'package:code_alpha_campus_event/colors.dart';
import 'package:code_alpha_campus_event/components/app_bar.dart';
import 'package:code_alpha_campus_event/components/event_button.dart';
import 'package:code_alpha_campus_event/config/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => eventsState();
}

class eventsState extends State<Events> {
  String get baseUrl => Bankend.link;
  List<dynamic> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    getEvent();
  }

  final FlutterSecureStorage storage = FlutterSecureStorage();
  List<dynamic> events = [];

  String _selectedButton = "All";
  bool isSearching = false;
  String? selectedEventId; // Track selected event ID

  void _handleButtonPress(String buttonText) {
    setState(() {
      _selectedButton = buttonText;
      _filterEvents(); // Update selected button
    });
  }

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

  PreferredSizeWidget buildSearchAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: AppColors.font2,
        ),
        onPressed: stopSearch, // Go back to the default app bar
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

  PreferredSizeWidget defaultAppBar() {
    return CustomAppBar(
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: startSearch, // Switch to the search app bar
        ),
        PopupMenuButton<String>(
            color: AppColors.background,
            elevation: 0,
            onSelected: (value) {
              // Handle menu selection
              switch (value) {
                case 'edit':
                  if (selectedEventId != null) {
                    Navigator.pushNamed(
                      context,
                      AppRoute.edit,
                      arguments:
                          selectedEventId, // Passing eventId as the argument
                    );
                  } else {
                    showErrorDialog(
                        context, 'select event', 'select event first');
                  }

                  break;
                case 'link':
                  // Navigator.pushNamed(context, AppRoute.link);
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: AppColors.font2),
                      SizedBox(width: 10),
                      Text("Edit", style: TextStyle(color: AppColors.font2)),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete, color: AppColors.font2),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          if (selectedEventId != null) {
                            showConfirmationDialog(context, () {
                              deleteEvent(
                                  selectedEventId!); // Only delete after confirmation
                            });
                          } else {
                            showErrorDialog(
                                context, "Error", "No event selected.");
                          }
                        },
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                ),
              ];
            })
      ],
      name: 'Events',
    );
  }

  Future<void> deleteEvent(String eventId) async {
    print("event id to delete =====$eventId");
    try {
      String? token = await getToken();
      if (token != null) {
        final response = await http.delete(
          Uri.parse('$baseUrl/events/delete_event/$eventId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          // If the event is deleted successfully, refresh the event list
          setState(() {
            events.removeWhere((event) => event['_id'] == eventId);
            selectedEventId = null; // Clear the selected event after deletion
          });
          showErrorDialog(context, "Success", "Event deleted successfully ");
        } else {
          showErrorDialog(context, "Error", "Failed to delete the event.");
        }
      } else {
        showErrorDialog(context, "Error", "Token not found. Please log in.");
      }
    } catch (e) {
      showErrorDialog(context, "Error", "failed to access to database");
    }
  }

  // Function to retrieve events
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
            _filteredEvents = events;
          });
        } else {
          showErrorDialog(context, "Error", "Failed to load events.");
        }
      } else {
        showErrorDialog(context, "Error", "Token not found. Please log in.");
      }
    } catch (e) {
      showErrorDialog(context, "Error", "failed to access to database");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSearching ? buildSearchAppBar() : defaultAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 24.0, vertical: 10), // Padding around the list
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Column(
                children: [
                  const SizedBox(height: 10),
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
                  ..._filteredEvents.map((event) {
                    DateTime createdAt = DateTime.parse(event['createdAt']);
                    String formattedTime = DateFormat.jm().format(createdAt);
                    String formattedDate =
                        DateFormat.yMMMMd().format(createdAt);

                    return Column(
                      children: [
                        buildEventContainer(
                          title: event['title'],
                          description: event['description'],
                          dateTime: '$formattedDate - $formattedTime',
                          location: event['locationName'],
                          eventId: event['_id'],
                          onSelect: () {
                            setState(() {
                              selectedEventId =
                                  event['_id']; // Set selected event ID
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                      ],
                    );
                  }).toList(),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: AppColors.pressedButton,
        onPressed: () {
          Navigator.pushNamed(context, AppRoute.event);
        },
        child: const Icon(
          Icons.calendar_today,
          color: AppColors.font2,
        ),
      ),
    );
  }

  // Helper function to build individual event containers
  Widget buildEventContainer({
    required String title,
    required String description,
    required String dateTime,
    required String location,
    required String? eventId,
    required VoidCallback onSelect, // onSelect callback
  }) {
    return GestureDetector(
      onTap: onSelect, // Handle selection when tapped
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: selectedEventId == eventId
              ? AppColors.pressedButton
              : AppColors.single,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Title text color
              ),
            ),
            const SizedBox(
                height: 8.0), // Spacing between title and description
            Text(
              description,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.white70, // Description text color
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              dateTime,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.white60, // Date and time text color
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.white60, // Location icon color
                  size: 16.0, // Icon size
                ),
                const SizedBox(
                    width: 4.0), // Spacing between icon and location text
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.white60, // Location text color
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  // Helper function to show error dialog
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

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
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

  void showConfirmationDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Event'),
          content: const Text('Do you want to delete this event?'),
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
}
