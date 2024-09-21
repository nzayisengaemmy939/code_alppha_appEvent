import 'package:code_alpha_campus_event/colors.dart';
import 'package:flutter/material.dart';

class Notify extends StatefulWidget {
  const Notify({super.key});

  @override
  State<Notify> createState() => NotifyState();
}

class NotifyState extends State<Notify> {
  bool isSearching = false;

  void startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  void stopSearch() {
    setState(() {
      isSearching = false;
    });
  }

  PreferredSizeWidget defaultAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.font2,
      elevation: 0,
      titleSpacing: 0,
      centerTitle: false,
      title: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 24, bottom: 8, right: 16.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: AppColors.font1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Notification"),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: startSearch,
            ),
          ],
        ),
      ),
    );
  }
  PreferredSizeWidget _buildSearchAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back,color: AppColors.font2,),
        onPressed: stopSearch, // Go back to the default app bar
      ),
      backgroundColor: AppColors.background,
      elevation: 0,
      title: TextField(
  autofocus: true, // Automatically focus on the search bar
  decoration: const InputDecoration(
    hintText: 'Search...',
    hintStyle: TextStyle(color: AppColors.font2), // Custom hint text color
    border: InputBorder.none, // Remove default border
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1.0, color: AppColors.button), // White border
      borderRadius: BorderRadius.all(Radius.circular(50)), // Rounded corners
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1.0, color: AppColors.button), // White border on focus
      borderRadius: BorderRadius.all(Radius.circular(50)), // Rounded corners
    ),
    filled: true,
    fillColor: AppColors.button, // Background color of the TextField
  ),
  onChanged: (query) {
    setState(() {
      // Update search query as user types
    });
  },
  style: const TextStyle(color: AppColors.font2), // Custom text color
)

    );}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSearching?_buildSearchAppBar():defaultAppBar(), // Adding the AppBar here
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              BuildNot(
                title: "To t insontent.. FAB nt. This setubarclude a popup",
              ),
              const SizedBox(height: 10),
              BuildNot(
                title: "To t insontent.. FAB nt. This setubarclude a popup",
              ),
              const SizedBox(height: 10),
              BuildNot(
                title: "To t insontent.. FAB nt. This setubarclude a popup",
              ),
            ],
          ),
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
        width: 40.0,
        height: 40.0,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage("assets/images/emmy.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: AppColors.button,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: AppColors.font2,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pressedButton,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 2.0),
                    ),
                    child: const Text(
                      "Accept",
                      style: TextStyle(color: AppColors.font2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pressedButton,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 2.0),
                    ),
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: AppColors.font2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
