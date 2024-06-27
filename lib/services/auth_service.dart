import 'package:budget_tracker/screens/dashboard.dart';
import 'package:budget_tracker/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class AuthService{
  var db = Db();
  createUser(data, context) async {
    try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: data['email'],
      password: data['password'],
    );
    await db.addUser(data, context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Registered Successfully...'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: ((context) => Dashboard())),
                );
              },
            ),
          ],
        );
      },
    );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Registration Failed...!!!"),
            content : Text("User already exists...! Please connected with Internet or Wifi."),
          );
        });
    }
  }
  login(data, context) async {
    try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: data['email'],
      password: data['password'],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Logged In Successfully...'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              },
            ),
          ],
        );
      },
    );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Login Failed...!!!"),
            content : Text("No such type email or password found...!, Please enter email and password carefully. Please connected with Internet or Wifi."),
          );
        });
    }
  }
}