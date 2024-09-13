import 'package:code_alpha_campus_event/app_styles.dart';
import 'package:code_alpha_campus_event/colors.dart';
import 'package:code_alpha_campus_event/config/app_route.dart';
import 'package:flutter/material.dart';

class AppEvent extends StatelessWidget {
  const AppEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the single page when the row is tapped
        Navigator.pushNamed(context, AppRoute.single);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
        children: [
          // Profile image container
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
          const SizedBox(width: 15.0), // Add spacing between image and text

          // Expanded text section
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Event title
                    Text(
                      "Dusengimana",
                      style: TextStyle(
                        fontSize: AppStyles.fontsize2,
                        color: AppColors.font2,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    // Event time
                    Text(
                      "7:00:12 am",
                      style: TextStyle(
                        fontSize: AppStyles.fontsize4,
                        color: AppColors.font1,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                const SizedBox(height: 10.0), // Space between rows
                // Event description
                Row(
                  children: const [
                    Text(
                      "Career Failure",
                      style: TextStyle(
                        fontSize: AppStyles.fontsize3,
                        color: AppColors.font2,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
