import 'package:code_alpha_campus_event/app_styles.dart';
import 'package:code_alpha_campus_event/colors.dart';
import 'package:flutter/material.dart';

class Single extends StatelessWidget {
  const Single({super.key});

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
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Title
              const Text(
                "Career Failure Event",
                style: TextStyle(
                  fontSize: AppStyles.fontsize2, // Title font size
                  fontWeight: FontWeight.bold, // Bold title
                  color: AppColors.font2, // Custom blue color for title
                ),
              ),
              const SizedBox(
                  height: 10.0), // Space between title and description

              // Event Description
              const Text(
                "This event focuses on career failures, sharing experiences, and providing "
                "solutions to overcome challenges in professional life. The event will feature "
                "keynote speakers who will talk about their personal experiences, tips for "
                "recovering from setbacks, and strategies for future growth.",
                style: TextStyle(
                  fontSize: AppStyles.fontsize3, // Description font size
                  color: AppColors.font1,
                   // Custom text color
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                  height: 20.0), // Space between description and details

              // Event Date and Time
              const Row(
                children: [
                  Icon(Icons.calendar_today,
                      color: AppColors.pressedButton), // Icon with blue color
                  SizedBox(width: 10),
                  Text(
                    "Date: September 13, 2024",
                    style: TextStyle(
                      fontSize: AppStyles.fontsize3,
                      color: AppColors.font1, // Custom text color
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0), // Space between rows

              const Row(
                children: [
                  Icon(Icons.access_time,
                      color: AppColors.pressedButton), // Icon with blue color
                  SizedBox(width: 10),
                  Text(
                    "Time: 7:00 AM - 10:00 AM",
                    style: TextStyle(
                      fontSize: AppStyles.fontsize3,
                      color: AppColors.font1, // Custom text color
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0), // Space between time and location

              // Event Location
              const Row(
                children: [
                  Icon(Icons.location_on,
                      color: AppColors.pressedButton), // Icon with blue color
                  SizedBox(width: 10),
                  Text(
                    "Location: Kigali Convention Center",
                    style: TextStyle(
                      fontSize: AppStyles.fontsize3,
                      color: AppColors.font1, // Custom text color
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0), // Space after the details

              // Call to Action Button (optional)
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        // Action on button press
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.button, // Button color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13.0, vertical: 2.0),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(25.0), // Rounded corners
                        ),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            "12",
                            style: TextStyle(
                                color: AppColors.font2,
                                fontSize: AppStyles.fontsize3),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: AppColors.pressedButton,
                          )
                        ],
                      )),
                        SizedBox(
                            width: 10,
                          ),
                  ElevatedButton(
                      onPressed: () {
                        // Action on button press
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.button, // Button color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13.0, vertical: 2.0),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(25.0), // Rounded corners
                        ),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            "12",
                            style: TextStyle(
                                color: AppColors.font2,
                                fontSize: AppStyles.fontsize3),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.thumb_down_alt_outlined,
                            color: AppColors.pressedButton,
                          )
                        ],
                      )),
                        SizedBox(
                            width: 10,
                          ),
                  ElevatedButton(
                    onPressed: () {
                      // Action on button press
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 2.0),
                      backgroundColor: AppColors.pressedButton, // Button color
                      // padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        // Rounded corners
                      ),
                    ),
                    child: const Text(
                      "Attend Event",
                      style: TextStyle(
                        fontSize: AppStyles.fontsize3,
                        color: Colors.white, // White text on button
                      ),
                    ),
                  ),
                    SizedBox(
                            width: 10,
                          ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
