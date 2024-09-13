import 'package:code_alpha_campus_event/colors.dart';
import 'package:flutter/material.dart';

class Single extends StatelessWidget {
  const Single({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ],
        ),
      ),
      body: const Center(
        child: Column(
          children: [
            Text(
              "This single page",
              style: TextStyle(color: AppColors.font2),
            )
          ],
        ),
      ),
    );
  }
}
