import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Transaction {
  final String category;
  final double amount;
  final DateTime date;
  final bool isCredit;

  Transaction(this.category, this.amount, this.date, this.isCredit);

  factory Transaction.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Transaction(
      data['category'] ?? '',
      data['amount']?.toDouble() ?? 0.0,
      DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
      data['type'] == 'credit',
    );
  }
}

Future<Map<String, List<Transaction>>> fetchTransactions() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return {'credits': [], 'debits': []};
  
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('transactions')
      .orderBy('timestamp', descending: true)
      .get();

  List<Transaction> credits = [];
  List<Transaction> debits = [];

  for (var doc in snapshot.docs) {
    Transaction transaction = Transaction.fromFirestore(doc);
    if (transaction.isCredit) {
      credits.add(transaction);
    } else {
      debits.add(transaction);
    }
  }

  return {'credits': credits, 'debits': debits};
}
