import 'package:code_alpha_campus_event/colors.dart';
import 'package:code_alpha_campus_event/pages/dashboard.dart';
import 'package:code_alpha_campus_event/pages/events.dart';
import 'package:code_alpha_campus_event/pages/home.dart';
import 'package:code_alpha_campus_event/pages/notification.dart';
import 'package:code_alpha_campus_event/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  int _currentIndex = 0;
  List<Widget>? _pages; // Store the pages here

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<String?> getRole() async {
    final token = await getToken();
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['role'];
    } else {
      return null; // If no token, return null
    }
  }

  @override
  void initState() {
    super.initState();
    // Build pages when the widget initializes
    _initPages();
  }

  Future<void> _initPages() async {
    String? role = await getRole();
    print('User role: $role');

    // Build the pages based on the role
    setState(() {
      _pages = [
        const Home(),
        const Events(),
        const Notify(),
        role == 'admin' ? const Dashboard() : const Profile(),
      ];
    });
  }

  // Handle the BottomNavigationBar tap
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; // Update the current index
    });
    _pageController.jumpToPage(index); // Jump to the selected page
  }

  @override
  Widget build(BuildContext context) {
    // Ensure that _pages is not null before building the widget
    if (_pages == null) {
      return const Center(child: CircularProgressIndicator()); // Loading state
    }

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index; // Sync BottomNav with PageView swiping
          });
        },
        children: _pages!, // Display the pages
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
            icon: const Icon(
              Icons.home,
              color: AppColors.font2, // Default color when not active
              size: 30.0,
            ),
            activeIcon: Stack(
              children: [
                const Icon(
                  Icons.home,
                  color: Color(0xff1877F2), // Active color when selected
                  size: 30.0,
                ),
                // Circular new events indicator
                Positioned(
                  top: 0, // Position at the top of the icon
                  right: 0, // Position at the right of the icon
                  child: Container(
                    width: 18.0, // Width of the circle
                    height: 18.0, // Height of the circle
                    decoration: const BoxDecoration(
                      color: Colors
                          .red, // Red color for the circle (new events indicator)
                      shape: BoxShape.circle, // Circular shape
                    ),
                    child: const Center(child: Text('5',style: TextStyle(color: AppColors.font2),)),
                  ),
                ),
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
            icon: const Icon(
                Icons.notifications,
              color: AppColors.font2, // Default color when not active
              size: 30.0,
            ),
            activeIcon: Stack(
              children: [
                   Icon(
              Icons.notifications,
              size: 30.0,
              color: _currentIndex == 2
                  ? const Color(0xff1877F2)
                  : AppColors.font2,
            ),
                // Circular new events indicator
                Positioned(
                  top: 0, // Position at the top of the icon
                  right: 0, // Position at the right of the icon
                  child: Container(
                    width: 18.0, // Width of the circle
                    height: 18.0, // Height of the circle
                    decoration: const BoxDecoration(
                      color: Colors
                          .red, // Red color for the circle (new events indicator)
                      shape: BoxShape.circle, // Circular shape
                    ),
                    child: const Center(child: Text('5',style: TextStyle(color: AppColors.font2),)),
                  ),
                ),
              ],
            ),
            label: "Notification",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.notifications,
          //     size: 30.0,
          //     color: _currentIndex == 2
          //         ? const Color(0xff1877F2)
          //         : AppColors.font2,
          //   ),
          //   label: "Notifications",
          // ),
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
