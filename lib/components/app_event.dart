import 'package:code_alpha_campus_event/app_styles.dart';
import 'package:code_alpha_campus_event/colors.dart';
import 'package:code_alpha_campus_event/config/app_route.dart';
import 'package:flutter/material.dart';

class AppEvent extends StatelessWidget {
  final String name;
  final String title;
  final String created;
  final String image;
  final String eventId;
  

  late final Map<String, dynamic> arguments; // Declare as late

  AppEvent({
    required this.image,
    Key? key,
    required this.name,
    required this.title,
    required this.created,
    required this.eventId,
  }) : super(key: key) {
    arguments = {
      'eventId': eventId,
      'name': name,
      'image': image,
    };
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // print("e======================================ventid ${eventId}");

        Navigator.pushNamed(
          context,
          AppRoute.single,
          arguments: arguments,
         
        );
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
                image: _getImageProvider(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15.0),
          Expanded(
            // Use Expanded to take up the remaining space
            child: Column(
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
                    ),
                    Text(
                      created,
                      style: const TextStyle(
                        fontSize: AppStyles.fontsize4,
                        color: AppColors.font1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppStyles.fontsize3,
                    color: AppColors.font2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    } else {
      return AssetImage(imageUrl);
    }
  }
}
