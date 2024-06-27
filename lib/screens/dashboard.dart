import 'package:budget_tracker/screens/calendar.dart';
import 'package:budget_tracker/screens/finanalysis.dart';
import 'package:budget_tracker/screens/home.dart';
import 'package:budget_tracker/screens/login.dart';
import 'package:budget_tracker/screens/transaction.dart';
import 'package:budget_tracker/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var isLogoutLoading = false;
  int currentIndex = 0;
  var pageViewList = [
    HomeScreen(),
    TransactionScreen(),
    AnalysisScreen(),
    Calendar(),
  ];
  logOut() async {
    setState(() {
      isLogoutLoading = true;
    });
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
    );
    setState(() {
      isLogoutLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (int value) {
          setState(() {
            currentIndex = value;
          });
         },),
      body: pageViewList[currentIndex],
    );
  }
}