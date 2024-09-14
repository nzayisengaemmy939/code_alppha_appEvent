import 'package:code_alpha_campus_event/colors.dart';
import 'package:flutter/material.dart';

class AllLinks extends StatelessWidget {
  const AllLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.font2,
        title: const Text("Quick links"),
      ),
      body: const SingleChildScrollView(
        
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          
          child: Column(
            children: [
            SizedBox(height: 10,),
            Row(
            crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Icon(Icons.link,color: AppColors.font2,size: 30,),
                Expanded(child: Text("https://youtu.be/YeqOyBqLSEg?si=_AaukZxgMsVsviXO",style: TextStyle(color: AppColors.font2),))
              ],
            )

            ],
          ),
        ),
      ),
    );
  }
}