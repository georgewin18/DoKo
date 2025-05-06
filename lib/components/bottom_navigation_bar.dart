import 'package:doko/pages/home_page.dart';
import 'package:doko/pages/task_group_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    TaskGroupPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(
          context,
        ).copyWith(iconTheme: IconThemeData(color: Colors.white)),
        child: CurvedNavigationBar(
          color: const Color(0xFF4D107F),
          backgroundColor: Colors.transparent,
          animationCurve: Curves.ease,
          buttonBackgroundColor: const Color(0xFFE4D1F5),
          onTap: _onItemTapped,
          items: [
            CurvedNavigationBarItem(
              child: Icon(
                LucideIcons.house,
                color: _selectedIndex == 0 ? Color(0xFF4D107F) : Colors.white,
              ),
              label: 'Home',
              labelStyle: TextStyle(color: Colors.white), // Label tetap putih
            ),
            CurvedNavigationBarItem(
              child: Icon(
                LucideIcons.group,
                color:
                    _selectedIndex == 1
                        ? const Color(0xFF4D107F)
                        : Colors.white,
              ),
              label: 'Group',
              labelStyle: TextStyle(color: Colors.white), // Label tetap putih
            ),
          ],
        ),
      ),
    );
  }
}
