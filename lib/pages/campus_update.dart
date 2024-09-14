import 'package:code_alpha_campus_event/app_styles.dart';
import 'package:code_alpha_campus_event/colors.dart';
import 'package:flutter/material.dart';

class CampusUpdate extends StatelessWidget {
  const CampusUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.single,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.font2,
        title: const Row(
          children: [
            Center(child: Text("Campus Update")),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              campusUpdate(
                  title: "Umuganda",
                  des:
                      "Depending on your app’s functionality and user needs, you might also consider:"
                      "Link to an External Website: Open a webpage that displays the latest updates."
                      "Push Notifications: Integrate with a notification system to alert users of important updates."
                      "RSS Feed: Display updates from an RSS feed if available."
                      "Feel free to adjust the implementation to better fit your app’s design and functionality.",
                  time: "10:00 am"),
              const SizedBox(
                height: 10,
              ),
              campusUpdate(
                  title: "Umuganda",
                  des:
                      "Depending on your app’s functionality and user needs, you might also consider:"
                      "Link to an External Website: Open a webpage that displays the latest updates."
                      "Push Notifications: Integrate with a notification system to alert users of important updates."
                      "RSS Feed: Display updates from an RSS feed if available."
                      "Feel free to adjust the implementation to better fit your app’s design and functionality.",
                  time: "10:00 am"),
            ],
          ),
        ),
      ),
    );
  }
}

Widget campusUpdate({
  required String title,
  required String des,
  required String time,
}) {
  return (Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.button,
        ),
        child: const Center(
          child: Text(
            "C",
            style: TextStyle(
                color: AppColors.pressedButton,
                fontSize: AppStyles.fontsize2,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      const SizedBox(
        width: 15,
      ),
      Expanded(
          child: Column(
            children: [
              
             
              Text(title,
                  style: const TextStyle(
                      color: AppColors.font2, fontSize: AppStyles.fontsize2)),
              const SizedBox(
                height: 10,
              ),
              Text(des,
                  style: const TextStyle(
                      color: AppColors.font1, fontSize: AppStyles.fontsize3)),
                        const SizedBox(
                height: 10,
              ),
              Text(time,
                  style: const TextStyle(
                      color: AppColors.font2, fontSize: AppStyles.fontsize3))
            ],
          ))
    ],
  ));
}
