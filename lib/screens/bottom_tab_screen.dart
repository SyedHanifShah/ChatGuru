import 'package:chat_app/screens/calls_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class BottomTabs extends StatefulWidget {
  const BottomTabs({super.key});

  @override
  State<BottomTabs> createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _currentScreenIndex = 0;
  Widget currentScreen = const HomeScreen();

  void _selectTab(int index) {
    setState(() {
      _currentScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentScreenIndex == 1) {
      currentScreen = const CallsScreen();
    } else if (_currentScreenIndex == 2) {
      currentScreen = const SettingsScreen();
    } else {
      currentScreen = const HomeScreen();
    }

    return Scaffold(
      body: currentScreen,
      bottomNavigationBar: BottomNavigationBar(
          selectedIconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.primary),
          unselectedIconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.secondary),
          onTap: _selectTab,
          currentIndex: _currentScreenIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.message_rounded), label: 'Message'),
            BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Calls'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
          ]),
    );
  }
}
