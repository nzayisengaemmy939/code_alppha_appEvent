import 'package:code_alpha_campus_event/colors.dart';
import 'package:code_alpha_campus_event/pages/events.dart';
import 'package:code_alpha_campus_event/pages/home.dart';
import 'package:code_alpha_campus_event/pages/notification.dart';
import 'package:code_alpha_campus_event/pages/profile.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  // PageController to control the PageView
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const Home(),
    const Events(),
    const Notify(),
    const Profile(),
  ];

  // Handle the BottomNavigationBar tap
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Jump to the selected page in the PageView
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // PageView to enable left/right swiping
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index; // Sync BottomNav with PageView swiping
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        elevation: 0,
        backgroundColor: AppColors.background,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.font2,
        unselectedItemColor: AppColors.font2,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(
                  Icons.home,
                  color: _currentIndex == 0
                      ? const Color(0xff1877F2)
                      : AppColors.font2,
                  size: 30.0,
                ),
                Positioned(
                  right: 0,
                  top: -1,
                  child: Container(
                    width: 17.0,
                    height: 17.0,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 241, 28, 28),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        "5",
                        style: TextStyle(
                          color: AppColors.font2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.event,
              color: _currentIndex == 1
                  ? const Color(0xff1877F2)
                  : AppColors.font2,
              size: 25.0,
            ),
            label: "Events",
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(
                  Icons.notifications,
                  size: 30.0,
                  color: _currentIndex == 2
                      ? const Color(0xff1877F2)
                      : AppColors.font2,
                ),
                Positioned(
                  right: 0,
                  top: -1,
                  child: Container(
                    width: 17.0,
                    height: 17.0,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 241, 28, 28),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        "5",
                        style: TextStyle(
                          color: AppColors.font2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _currentIndex == 3
                  ? const Color(0xff1877F2)
                  : AppColors.font2,
              size: 25.0,
            ),
            label: "Me",
          ),
        ],
        onTap: _onItemTapped, // Handle BottomNav item tap
      ),
    );
  }
}
