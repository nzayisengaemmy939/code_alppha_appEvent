import 'package:code_alpha_campus_event/colors.dart';
import 'package:flutter/material.dart';

class Edit extends StatelessWidget {
  const Edit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.single,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.font2,
        title: Text("Edit event"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: AppColors.font2),
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: AppColors.red)),
                filled: true,
                hoverColor: AppColors.font1,
                fillColor: AppColors.single,
              ),
              style: TextStyle(
                color: AppColors.font2, // Change the text color to blue
                fontSize: 16, // Customize font size
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: AppColors.font2),
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: AppColors.red)),
                filled: true,
                hoverColor: AppColors.font1,
                fillColor: AppColors.single,
              ),
              style: TextStyle(
                color: AppColors.font2, // Change the text color to blue
                fontSize: 16, // Customize font size
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: AppColors.font2),
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: AppColors.red)),
                filled: true,
                hoverColor: AppColors.font1,
                fillColor: AppColors.single,
              ),
              style: TextStyle(
                color: AppColors.font2, // Change the text color to blue
                fontSize: 16, // Customize font size
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: AppColors.font2),
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: AppColors.red)),
                filled: true,
                hoverColor: AppColors.font1,
                fillColor: AppColors.single,
              ),
              style: TextStyle(
                color: AppColors.font2, // Change the text color to blue
                fontSize: 16, // Customize font size
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: AppColors.font2),
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: AppColors.red)),
                filled: true,
                hoverColor: AppColors.font1,
                fillColor: AppColors.single,
              ),
              style: TextStyle(
                color: AppColors.font2, // Change the text color to blue
                fontSize: 16, // Customize font size
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {},style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.single,
                    side: BorderSide(
                      width: 1,
                      color: AppColors.font1
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      
                      
                    )
                    
                  ),
                  child: const Text(
                    "Send",
                    style: TextStyle(color: AppColors.font2),
                  
                  ),),
            )
          ],
        ),
      ),
    );
  }
}
