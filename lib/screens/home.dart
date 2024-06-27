import 'package:budget_tracker/screens/login.dart';
import 'package:budget_tracker/services/db.dart';
import 'package:budget_tracker/widgets/add_transac_form.dart';
import 'package:budget_tracker/widgets/hero_card.dart';
import 'package:budget_tracker/widgets/transaction_cards.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLogoutLoading = false;
  String? firstname;
  final Db db = Db();

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  fetchUsername() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final fullusername = await db.getUsername(userId);
    setState(() {
      firstname = fullusername?.split(' ').first;
    });
  }

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

  final userId = FirebaseAuth.instance.currentUser!.uid;

  _dialogBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: AddTransacForm(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 194, 28, 78),
        onPressed: (() {
          _dialogBuilder(context);
        }),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 207, 50, 97),
        title: Text(
          "Hello ${firstname ?? ''},",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              logOut();
            },
            icon: isLogoutLoading
                ? CircularProgressIndicator()
                : Icon(Icons.exit_to_app, color: Colors.white),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Column(
                children: [
                  HeroCard(userId: userId),
                  Container(
                    color: Color.fromARGB(255, 207, 50, 97),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Container(), 
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                      color: Color.fromARGB(255, 250, 237, 241),
                    ),
                    child: TransactionsCard(),
                  ),
                ],
              ),
              color: Color.fromARGB(255, 207, 50, 97),
            ),
          ],
        ),
      ),
    );
  }
}
