import 'package:flutter/material.dart';

// MainScreen is the Widget; holds configuration (data) like screens and navItems; MainScreen = Blueprint + Inputs
class MainScreen extends StatefulWidget {
  final List<Widget> screens;
  final List<BottomNavigationBarItem> navItems;
  const MainScreen({super.key, required this.screens, required this.navItems})
    : assert(
        screens.length == navItems.length,
        'screens and navItems must have the same length',
      );
  @override
  State<MainScreen> createState() => _MainScreenState();
}

// _MainScreenState is the State which holds mutable state, here _selectedIndex. It gives you 'widget' meaning the current MainScreen object that created this state; _MainScreenState = Machine running that blueprint
class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack holds multiple children (alive), but shows only ONE at a time based on an index; if we were to use simple widget.screens[_selectedIndex], other screens would be destroyed and state would be lost
      body: IndexedStack(index: _selectedIndex, children: widget.screens),
      // widget.screens[_selectedIndex] means- access the screens list that was passed into MainScreen and pick one based on current state
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
        selectedItemColor: const Color(0xFF061827),
        items: widget.navItems,
      ),
    );
  }
}
