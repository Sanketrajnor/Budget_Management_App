import 'package:budget_tracker/utils/icons_list.dart';
import 'package:budget_tracker/widgets/transaction_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransactionsCard extends StatelessWidget {
  TransactionsCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Recent Transactions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              )
            ],
          ),
          RecentTransactionList()
        ],
      ),
    );
  }
}

class RecentTransactionList extends StatelessWidget {
  RecentTransactionList({
    super.key,
  });

  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection("transactions")
      .orderBy('timestamp', descending: true)
      .limit(20)
      .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.connectionState == ConnectionState.waiting){
          return Text("Loading");
        }else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No transactions found."));
        }

        var data = snapshot.data!.docs;

      
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index){
        var cardData = data[index];
        return TrasactionCard(data: cardData,);
      }
    );
    });
  }
}

