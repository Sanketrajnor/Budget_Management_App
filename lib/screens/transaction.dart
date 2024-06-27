import 'package:budget_tracker/widgets/category_list.dart';
import 'package:budget_tracker/widgets/tab_bar_view.dart';
import 'package:budget_tracker/widgets/timeline_month.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  var category = "All";
  var monthYear = "";

  void initState(){
    super.initState();
    DateTime now = DateTime.now();
    setState(() {
      monthYear = DateFormat('MMM y').format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 194, 28, 78),
        title: Text("Expansive",
        textAlign: TextAlign.center,
        style: TextStyle(
              fontSize: 28, // Set the font size
              fontWeight: FontWeight.bold, // Set the font weight
              color: Colors.white, // Set the font color
          ),
        ),
      ),
      body: Column(
          children: [
            TimelineMonth(onChanged: (String? value) {
              if(value != null){
                setState(() {
                  monthYear= value;
                });
              }
            },),
            CategoryList(onChanged: (String? value) {
              if(value != null){
                setState(() {
                  category = value;
                });
              }
            },),
            TypeTabBar(category: category, monthYear: monthYear,),
          ],
        ),
    );
  }
}