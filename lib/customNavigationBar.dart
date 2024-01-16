
import 'package:flutter/material.dart';

import 'home.dart';
import 'history.dart';
import 'summary.dart';

///
///  The navigation bar widget
///
class CustomNavigationBar extends StatelessWidget {
  final int initialIndex; // Determines initial tab displayed

  const CustomNavigationBar({super.key, required this.initialIndex});

  // Handles tap events on navigation bar items
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
      // Navigates to the Home screen
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Home(title: 'Welcome to My Baby Tracker!')));
        break;
      case 1:
      // Navigates to the History screen
        Navigator.push(context, MaterialPageRoute(builder: (context) => const History(title: 'My History List')));
        break;
      case 2:
      // Navigates to the Summary screen
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Summary(title: 'My Daily Summary')));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Summary',
        ),
      ],
      currentIndex: initialIndex, // Sets the currently active tab
      selectedItemColor: Colors.amber[800], // Color of selected tab
      onTap: (index) => _onItemTapped(index, context), // Tap handling
      selectedLabelStyle: const TextStyle(fontSize: 20), // Style for selected label
      selectedIconTheme: const IconThemeData(size: 30), // Style for selected icon
    );
  }
}