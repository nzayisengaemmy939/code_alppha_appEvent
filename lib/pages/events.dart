import 'package:code_alpha_campus_event/colors.dart';
import 'package:code_alpha_campus_event/components/app_bar.dart';
import 'package:code_alpha_campus_event/components/event_button.dart';
import 'package:flutter/material.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  String _selectedButton = "All";
  void _handleButtonPress(String buttonText) {
    setState(() {
      _selectedButton = buttonText; // Update selected button
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          IconButton(
            icon:
                const Icon(Icons.search, color: AppColors.font2), // Search icon
            onPressed: () {
              // Action for search icon
            },
          ),
          PopupMenuButton<String>(
            color: AppColors.background,
            elevation: 0,
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
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: AppColors.font2),
                      SizedBox(width: 10),
                      Text("Delete", style: TextStyle(color: AppColors.font2)),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'special_notification',
                  child: Row(
                    children: [
                      Icon(Icons.info, color: AppColors.font2),
                      SizedBox(width: 10),
                      Text("Special Notification",
                          style: TextStyle(color: AppColors.font2)),
                    ],
                  ),
                ),
              ];
            },
            onSelected: (value) {
              // Handle menu selection
              switch (value) {
                case 'edit':
                  // Handle edit action
                  break;
                case 'delete':
                  // Handle delete action
                  break;
                case 'special_notification':
                  // Handle special notification action
                  break;
              }
            },
          ),
        ],
        name: "Events",
      ),
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
                     const SizedBox(width: 10,),
                  EventButton(
                    text: "Academic",
                    isSelected: _selectedButton == "Academic",
                    onPressed: () => _handleButtonPress("Academic"),
                  ),
                     const SizedBox(width: 10,),
                  EventButton(
                    text: "Social",
                    isSelected: _selectedButton == "Social",
                    onPressed: () => _handleButtonPress("Social"),
                  ),
                   const SizedBox(width: 10,),
                  EventButton(
                    text: "Sport",
                    isSelected: _selectedButton == "Sport",
                    onPressed: () => _handleButtonPress("Sport"),
                  ),
                ],
              ),
             const SizedBox(height: 10,),
              buildEventContainer(
                title: 'Career Seminar',
                description:
                    'Learn how to navigate your career after graduation.',
                dateTime: 'Sept 20, 2024 - 10:00 AM',
                location: 'Main Hall, Building A',
              ),
              const SizedBox(height: 16.0), // Spacing between events
              buildEventContainer(
                title: 'Coding Workshop',
                description:
                    'A hands-on workshop to improve your Flutter skills.',
                dateTime: 'Sept 25, 2024 - 2:00 PM',
                location: 'Tech Room, Building B',
              ),
              const SizedBox(height: 16.0),
              buildEventContainer(
                title: 'Campus Sports Day',
                description: 'Join us for a day full of sports activities!',
                dateTime: 'Oct 5, 2024 - 9:00 AM',
                location: 'Campus Field',
              ),
               const SizedBox(height: 16.0),
              buildEventContainer(
                title: 'Campus Sports Day',
                description: 'Join us for a day full of sports activities!',
                dateTime: 'Oct 5, 2024 - 9:00 AM',
                location: 'Campus Field',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: AppColors.pressedButton,
        onPressed: () {
          // Action for floating button
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
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2E2E), // Background color #2E2E2E
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
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
          const SizedBox(height: 8.0), // Spacing between title and description
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
        ],
      ),
    );
  }
}
