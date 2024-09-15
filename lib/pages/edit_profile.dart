import 'package:code_alpha_campus_event/colors.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.single,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.font2,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              width: 40.0, // Set width of the image container
              height: 40.0, // Set height of the image container
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage("assets/images/emmy.jpg"),
                  fit: BoxFit.cover, // Make sure the image covers the circle
                ),
              ),
            ),
            const SizedBox(width: 15),
            const Text("Brw Etsienne"),
            const Spacer(), // To push the icons to the right
            // IconButton(
            //   icon: Icon(Icons.settings, color: Color(0xFF1A73E9)),
            //   onPressed: () {
            //     // Define the action for the settings icon
            //   },
            // ),
            // IconButton(
            //   icon: Icon(Icons.help_outline, color: Color(0xFF1A73E9)),
            //   onPressed: () {
            //     // Define the action for the help icon
            //   },
            // ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const TextField(
                  decoration: InputDecoration(
                    hintText: "First Name",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    hoverColor: AppColors.font1,
                    fillColor: AppColors.single,
                    prefixIcon: Icon(Icons.person, color: Color(0xFF1A73E9)),
                  ),
                  style: TextStyle(
                    color: AppColors.font2, // Change the text color to blue
                    fontSize: 16, // Customize font size
                  ),
                ),
                const SizedBox(height: 10.0),
                const TextField(
                  decoration: InputDecoration(
                    hintText: "Second Name",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    hoverColor: AppColors.font1,
                    fillColor: AppColors.single,
                    prefixIcon: Icon(Icons.person, color: Color(0xFF1A73E9)),
                  ),
                  style: TextStyle(
                    color: AppColors.font2, // Change the text color to blue
                    fontSize: 16, // Customize font size
                  ),
                ),
                const SizedBox(height: 10.0),
                const TextField(
                  decoration: InputDecoration(
                    hintText: "UserName",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    hoverColor: AppColors.font1,
                    fillColor: AppColors.single,
                    prefixIcon: Icon(Icons.account_circle, color: Color(0xFF1A73E9)),
                  ),
                  style: TextStyle(
                    color: AppColors.font2, // Change the text color to blue
                    fontSize: 16, // Customize font size
                  ),
                ),
                const SizedBox(height: 10.0),
                const TextField(
                  decoration: InputDecoration(
                    hintText: "nzayisengaemmy2001@gmail.com",
                    hintStyle: TextStyle(color: AppColors.font2),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: AppColors.red)),
                    filled: true,
                    hoverColor: AppColors.font1,
                    fillColor: AppColors.single,
                    prefixIcon: Icon(Icons.email, color: Color(0xFF1A73E9)),
                  ),
                  style: TextStyle(
                    color: AppColors.font2, // Change the text color to blue
                    fontSize: 16, // Customize font size
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.single,
                      side: BorderSide(
                        width: 1,
                        color: AppColors.font1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      "Edit",
                      style: TextStyle(color: AppColors.font2),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
