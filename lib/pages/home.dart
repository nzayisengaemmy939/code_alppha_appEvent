import 'package:code_alpha_campus_event/colors.dart';
import 'package:code_alpha_campus_event/components/app_bar.dart';
import 'package:code_alpha_campus_event/components/app_event.dart';
import 'package:code_alpha_campus_event/components/event_button.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _selectedButton = "All"; // Default selected button
  bool _isSearching = false; // Flag to control the search bar visibility

  // Handle button press
  void _handleButtonPress(String buttonText) {
    setState(() {
      _selectedButton = buttonText; // Update selected button
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
        icon: const Icon(Icons.arrow_back,color: AppColors.font2,),
        onPressed: _stopSearch, // Go back to the default app bar
      ),
      backgroundColor: AppColors.background,
      elevation: 0,
      title: TextField(
  autofocus: true, // Automatically focus on the search bar
  decoration: const InputDecoration(
    hintText: 'Search...',
    hintStyle: TextStyle(color: AppColors.font2), // Custom hint text color
    border: InputBorder.none, // Remove default border
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1.0, color: AppColors.button), // White border
      borderRadius: BorderRadius.all(Radius.circular(50)), // Rounded corners
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1.0, color: AppColors.button), // White border on focus
      borderRadius: BorderRadius.all(Radius.circular(50)), // Rounded corners
    ),
    filled: true,
    fillColor: AppColors.button, // Background color of the TextField
  ),
  onChanged: (query) {
    setState(() {
      // Update search query as user types
    });
  },
  style: TextStyle(color: AppColors.font2), // Custom text color
)

    );
  }

  // Build the default app bar with a search icon and popup menu
  PreferredSizeWidget _buildDefaultAppBar() {
    return CustomAppBar(
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _startSearch, // Switch to the search app bar
        ),
        PopupMenuButton<String>(
          color: AppColors.background, // Customize popup menu background color
          onSelected: (String value) {
            // Handle the selected menu item
            print("Selected: $value");
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem<String>(
                value: 'Profile',
                child: Row(
                  children: [
                    Icon(Icons.update, color: AppColors.font2),
                    SizedBox(width: 8),
                    Text('Campus Update', style: TextStyle(color: AppColors.font1)),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Settings',
                child: Row(
                  children: [
                    Icon(Icons.link, color: AppColors.font2),
                    SizedBox(width: 8),
                    Text('Quick Links', style: TextStyle(color: AppColors.font1)),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Logout',
                child: Row(
                  children: [
                    Icon(Icons.notifications, color: AppColors.font2),
                    SizedBox(width: 8),
                    Text('Special Notification', style: TextStyle(color: AppColors.font1)),
                  ],
                ),
              ),
            ];
          },
          icon: const Icon(
            Icons.more_vert,
            color: AppColors.font2, // Customize the icon color
          ), // Customize the icon
        ),
      ],name: "Incoming Events",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearching ? _buildSearchAppBar() : _buildDefaultAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0,right: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
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
              ),
              const SizedBox(height: 10),
              const AppEvent(),
              const SizedBox(height: 10),
              const AppEvent(),
              const SizedBox(height: 10),
              const AppEvent(),
              const SizedBox(height: 10),
              const AppEvent(),
              const SizedBox(height: 10),
              const AppEvent(),
              const SizedBox(height: 10),
              const AppEvent(),
              const SizedBox(height: 10),
              const AppEvent(),
            ],
          ),
        ),
      ),
    );
  }
}
