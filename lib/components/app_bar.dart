import 'package:flutter/material.dart';
import 'package:code_alpha_campus_event/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;
  final String name;

  const CustomAppBar({super.key, required this.actions, required this.name,});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: AppColors.font2,
      backgroundColor: AppColors.background,
      elevation: 0, // Remove shadow
      titleSpacing: 0, // Ensures the title can extend fully
      centerTitle: false, // Prevent title from being centered
      title: Container(
        width: double.infinity, // Ensures the container spans the full width
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.font1, // Set bottom border color
              width: 1.0, // Set bottom border width
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0), // Set left padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                name,
                style: const TextStyle(
                  fontSize: 20.0, // Custom text size
                  fontWeight: FontWeight.bold, // Make the text bold
                  color: AppColors.font2, // Use a custom color for the title text
                ),
              ),
              Row(
                children: actions, // Use actions parameter
              ),
            ],
          ),
        ),
        
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
