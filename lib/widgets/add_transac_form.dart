import 'package:budget_tracker/utils/appvalidator.dart';
import 'package:budget_tracker/widgets/category_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddTransacForm extends StatefulWidget {
  const AddTransacForm({super.key});

  @override
  State<AddTransacForm> createState() => _AddTransacFormState();
}

class _AddTransacFormState extends State<AddTransacForm> {
  var type = "credit";
  var category = "Other";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var isLoader = false;
  var appValidator = new AppValidator();
  var amountEditController = TextEditingController();
  var titleEditController = TextEditingController();
  var uid = Uuid();

  Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      final user = FirebaseAuth.instance.currentUser;
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      var amount = int.parse(amountEditController.text);
      DateTime date = DateTime.now();
      var id = uid.v4();
      String monthyear = DateFormat('MMM y').format(date);

      final userDoc = await FirebaseFirestore.instance
      .collection('users').doc(user!.uid).get();

      int remainingAmount = userDoc['remainingAmount'];
      int totalCredit = userDoc['totalCredit'];
      int totalDebit = userDoc['totalDebit'];
      
      if(type == 'credit') {
        remainingAmount += amount;
        totalCredit += amount;
      } else {
        remainingAmount -= amount;
        totalDebit += amount;
      }

      await FirebaseFirestore.instance
            .collection('users').
            doc(user!.uid).
            update({
              "remainingAmount": remainingAmount,
              "totalCredit": totalCredit,
              "totalDebit": totalDebit,
              "updatedAt": timestamp,
            });

      var data = {
        "id": id,
        "title": titleEditController.text,
        "amount": amount,
        "type": type,
        "totalCredit": totalCredit,
        "totalDebit": totalDebit,
        "remainingAmount": remainingAmount,
        "monthyear": monthyear,
        "category": category,
        "timestamp": timestamp,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection("transactions")
          .doc(id)
          .set(data);

      Navigator.pop(context);      

      setState(() {
      isLoader = false;
      }); 
    }
    // showDialog(
    //   context: _formKey.currentContext!,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: const Text('Success'),
    //       content: const Text('Successfully Logged In...'),
    //       actions: <Widget>[
    //         TextButton(
    //           child: const Text('OK'),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
  }
}
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: titleEditController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: appValidator.isEmptyCheck,
              decoration: InputDecoration(
                labelText: 'Title'
              ),
            ),
            TextFormField(
              controller: amountEditController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: appValidator.isEmptyCheck,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount'
              ),
            ),
            CategoryDropdown(
              cattype: category,
              onChanged: (String? value){
                if(value != null){
                  setState(() {
                    category = value;
                  });
                }
              }
            ),
            DropdownButtonFormField(
              value: 'credit',
              items: [
                DropdownMenuItem(child: Text('Credit'),value: 'credit',),
                DropdownMenuItem(child: Text('Debit'),value: 'debit',),
              ], onChanged: (value){
                if(value != null){
                  setState(() {
                    type = value;
                  });
                }
              }),
          SizedBox(height: 16,),
          ElevatedButton(
            onPressed: () {
              if(isLoader == false){
                _submitForm();
              }
            }, 
            child: 
            isLoader ? Center(child: CircularProgressIndicator()):
            Text("Add Transaction"))
          ],
        ),
      ),
    );
  }
}