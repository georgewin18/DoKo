import 'package:app/pages/focus_mode_page.dart';
import 'package:app/pages/home_page.dart';
import 'package:app/pages/task_group_page.dart';
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

  final List<Widget> _pages = [HomePage(), TaskGroupPage(), FocusModePage()];

  @override
  void initState() {
    super.initState();
  }

  void onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(iconTheme: IconThemeData(color: Colors.white)),
              child: CurvedNavigationBar(
                color: const Color(0xFF4D107F),
                backgroundColor: Colors.transparent,
                animationCurve: Curves.ease,
                buttonBackgroundColor: const Color(0xFFE4D1F5),
                index: _selectedIndex,
                onTap: onItemTapped,
                items: [
                  CurvedNavigationBarItem(
                    child: Icon(
                      LucideIcons.house,
                      color:
                          _selectedIndex == 0
                              ? Color(0xFF4D107F)
                              : Colors.white,
                    ),
                    label: 'Home',
                    labelStyle: TextStyle(color: Colors.white),
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
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  CurvedNavigationBarItem(
                    child: Icon(
                      LucideIcons.timer_reset,
                      color:
                          _selectedIndex == 2
                              ? const Color(0xFF4D107F)
                              : Colors.white,
                    ),
                    label: 'Focus',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
