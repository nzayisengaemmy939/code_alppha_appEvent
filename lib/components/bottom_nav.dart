import 'package:code_alpha_campus_event/colors.dart';
import 'package:code_alpha_campus_event/pages/home.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;  // Default index is 0, so HomePage is the default page

  // Pages for each BottomNav item
  final List<Widget> _pages = [
    const Home(),
    const Center(child: Text("Events"),),
    const Center(child: Text("Calendar"),),
    const Center(child: Text("Notifications"),),
    const Center(child: Text("Me"),),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],  // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,  // Track selected index
        backgroundColor: AppColors.background,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.font2,  // Color for selected item icon
        unselectedItemColor: AppColors.font2,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home, 
              color: _currentIndex == 0 ? const Color(0xff1877F2) : AppColors.font2
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.event, 
              color: _currentIndex == 1 ? const Color(0xff1877F2) : AppColors.font2
            ),
            label: "Events",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.font1, width: 1.0),  // Border color
                borderRadius: BorderRadius.circular(4.0),  // Rounded corners
              ),
              child: Icon(
                Icons.calendar_month_outlined,
                color: _currentIndex == 2 ? const Color(0xff1877F2) : AppColors.font2,
                size: 16,
              ),
            ),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              color: _currentIndex == 3 ? const Color(0xff1877F2) : AppColors.font2,
            ),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _currentIndex == 4 ? const Color(0xff1877F2) : AppColors.font2,
            ),
            label: "Me",
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;  // Update the selected index
          });
        },
      ),
    );
  }
}
