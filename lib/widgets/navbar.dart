import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key, required this.selectedIndex, required this.onDestinationSelected});
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        onDestinationSelected: onDestinationSelected,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        height: 60,
        indicatorColor: const Color.fromARGB(255, 15, 7, 255),
        backgroundColor: Color.fromARGB(255, 242, 185, 200),
        selectedIndex: selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: Color.fromARGB(255, 255, 255, 255),),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore, color: Color.fromARGB(255, 255, 255, 255),),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_chart_outlined, color: Color.fromARGB(255, 255, 255, 255),),
            label: 'Analysis',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined, color: Color.fromARGB(255, 255, 255, 255),),
            label: 'Calender',
          ),
        ],
      );
  }
}