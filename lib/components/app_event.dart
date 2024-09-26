import 'package:code_alpha_campus_event/app_styles.dart';
import 'package:code_alpha_campus_event/colors.dart';
import 'package:code_alpha_campus_event/config/app_route.dart';
import 'package:flutter/material.dart';

class AppEvent extends StatelessWidget {
  final String name;
  final String title;
  final String created;
  final String image; // Change to String

  AppEvent({
    required this.image, // Move this to the required parameters
    Key? key, // Use Key? for optional key parameter
    required this.name,
    required this.title,
    required this.created,
  }) : super(key: key); // Call the superclass constructor

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the single page when the row is tapped
        Navigator.pushNamed(context, AppRoute.single);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile image container
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: _getImageProvider(image), // Get image provider
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15.0),
      
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: AppStyles.fontsize2,
                      color: AppColors.font2,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                  ),
            
                  Text(
                    created,
                    style: const TextStyle(
                      fontSize: AppStyles.fontsize4,
                      color: AppColors.font1,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              // Event title
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
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
        ],
      ),
    );
  }

  // Function to determine the ImageProvider based on the image string
  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      // If the URL starts with 'http', it's a network image
      return NetworkImage(imageUrl);
    } else {
      // Otherwise, it's assumed to be an asset image
      return AssetImage(imageUrl);
    }
  }
}
