import 'package:code_alpha_campus_event/colors.dart';
import 'package:flutter/material.dart';

class Notify extends StatelessWidget {
  const Notify({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.font2,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        title: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 24, bottom: 8, right: 16.0),
          decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 1, color: AppColors.font1))),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Notification"),
              Icon(Icons.search),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            BuildNot(
                title:
                    "To t insontent.."
                    "FAB nt."
                    "This setubarclude a popup "),
                    const SizedBox(height: 10,),
                      BuildNot(
                title:
                    "To t insontent.."
                    "FAB nt."
                    "This setubarclude a popup "), 
                     const SizedBox(height: 10,), 
                    BuildNot(
                title:
                    "To t insontent.."
                    "FAB nt."
                    "This setubarclude a popup "),
          ],
        ),
      ),
    );
  }
}

Widget BuildNot({required String title}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(width: 10,),
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
              color: AppColors.button,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
        
                  color:
                      AppColors.font2, // You can adjust this color to your preference
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(
                     backgroundColor: AppColors.pressedButton,
                    padding:const EdgeInsets.symmetric(horizontal: 12,vertical: 2.0)
                  ), child:  const Text("Accept",style: TextStyle(
                    color: AppColors.font2
                  ),),),
                     const SizedBox(width: 10,),
                   ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pressedButton,
                       padding:const EdgeInsets.symmetric(horizontal: 12,vertical: 2.0)
                   ), child:const  Text("Delete,",style: TextStyle(color: AppColors.font2),),),
                ],
              )
            ],
          ),
        ),
      ),
    ],
  );
}
