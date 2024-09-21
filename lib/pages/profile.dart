import 'package:code_alpha_campus_event/app_styles.dart';
import 'package:code_alpha_campus_event/colors.dart';
import 'package:code_alpha_campus_event/components/event_button.dart';
import 'package:code_alpha_campus_event/config/app_route.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _selectedButton = "All";
  void _handleButtonPress(String buttonText) {
    setState(() {
      _selectedButton = buttonText; // Update selected button
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              const SizedBox(width: 15),
              const Text("Brw Etsienne",
                  style: TextStyle(fontSize: AppStyles.fontsize3)),
              PopupMenuButton(
                color: AppColors.background,
                elevation: 0,
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                        child: Text("Change Mode",
                            style: TextStyle(color: AppColors.font2))),
                    const PopupMenuItem(
                      value: "edit_prof",
                      child: Text("Edit Profile",
                          style: TextStyle(color: AppColors.font2)),
                    ),
                    const PopupMenuItem(
                        child: Text("Logout",
                            style: TextStyle(color: AppColors.font2))),
                  ];
                },
                onSelected: (value) {
                  // Handle menu selection
                  switch (value) {
                    case 'edit_prof':
                      Navigator.pushNamed(context, AppRoute.profile);
                      break;
                    case 'link':
                      // Navigator.pushNamed(context, AppRoute.link);
                      break;
                  }
                },
              )
            ],
          ),
        ),
      ),
      body: Padding(
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
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("assets/images/emmy.jpg"),
                        fit: BoxFit.cover, // Make sure the image covers the circle
                      ),
                    ),
                  ),
                  const Positioned(
                      right: 5,
                      bottom: 0,
                      child: Icon(
                        Icons.edit,
                        color: Color(0xFF1A73E9), // Icon color
                      ))
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: SizedBox(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the Row horizontally
                  children: [
                    Text(
                      "@Emma Keen",
                      style: TextStyle(
                          color: AppColors.font2,
                          fontSize: AppStyles.fontsize2),
                    ),
                    SizedBox(width: 10),
                    Icon(
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "1",
                      style: TextStyle(
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
                Column(
                  children: [
                    Text(
                      "86",
                      style: TextStyle(
                          fontSize: AppStyles.fontsize2,
                          color: AppColors.font2),
                    ),
                    SizedBox(height: 10),
                    Text("Received",
                        style: TextStyle(
                            fontSize: AppStyles.fontsize3,
                            color: AppColors.font2)),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "76",
                      style: TextStyle(
                          fontSize: AppStyles.fontsize2,
                          color: AppColors.font2),
                    ),
                    SizedBox(height: 10),
                    Text("Canceled",
                        style: TextStyle(
                            fontSize: AppStyles.fontsize3,
                            color: AppColors.font2)),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "66",
                      style: TextStyle(
                          fontSize: AppStyles.fontsize2,
                          color: AppColors.font2),
                    ),
                    SizedBox(height: 10),
                    Text("Attend",
                        style: TextStyle(
                            fontSize: AppStyles.fontsize3,
                            color: AppColors.font2)),
                  ],
                )
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
              runSpacing: 4.0, // Add space between the rows vertically
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.button,
                  ),
                  child: const Text(
                    "Career ",
                    style: TextStyle(color: AppColors.font1),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.button,
                  ),
                  child: const Text(
                    "Career ",
                    style: TextStyle(color: AppColors.font1),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.button,
                  ),
                  child: const Text(
                    "Career ",
                    style: TextStyle(color: AppColors.font1),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.button,
                  ),
                  child: const Text(
                    "Career ",
                    style: TextStyle(color: AppColors.font1),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.button,
                  ),
                  child: const Text(
                    "Career ",
                    style: TextStyle(color: AppColors.font1),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.button,
                  ),
                  child: const Text(
                    "Career ",
                    style: TextStyle(color: AppColors.font1),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.button,
                  ),
                  child: const Text(
                    "Career ",
                    style: TextStyle(color: AppColors.font1),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
