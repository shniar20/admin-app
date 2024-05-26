import 'package:employee/page/view_location.dart';
import 'package:employee/page/view_post.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          ViewLocation(),
          // AddPost(),
          ViewPost(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'ئاگاداريەکان',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.post_add_outlined),
          //   label: 'بڵاوکردنەوەی ڕێنمایی',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_agenda),
            label: 'بڵاوکراوەکان',
          ),
        ],
        selectedItemColor: const Color.fromARGB(
            255, 110, 14, 7), // Customize the selected item color
        unselectedItemColor: const Color.fromARGB(
            255, 87, 86, 86), // Customize the unselected item color
        selectedLabelStyle: const TextStyle(
            fontFamily: 'rabar'), // Change fontFamily for selected label
        unselectedLabelStyle: const TextStyle(
            fontFamily: 'rabar'), // Change fontFamily for unselected label
      ),
    );
  }
}
