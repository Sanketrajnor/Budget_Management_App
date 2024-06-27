import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionAnal {
  final String category;
  final double amount;
  final DateTime date;
  final bool isCredit;

  TransactionAnal(this.category, this.amount, this.date, this.isCredit);

  factory TransactionAnal.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return TransactionAnal(
      data['category'] ?? '',
      data['amount']?.toDouble() ?? 0.0,
      DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
      data['type'] == 'credit',
    );
  }
}

Future<Map<String, List<TransactionAnal>>> fetchTransactionsAnal() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return {'credits': [], 'debits': []};
  
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('transactions')
      .orderBy('timestamp', descending: true)
      .get();

  List<TransactionAnal> credits = [];
  List<TransactionAnal> debits = [];

  for (var doc in snapshot.docs) {
    TransactionAnal transaction = TransactionAnal.fromFirestore(doc);
    if (transaction.isCredit) {
      credits.add(transaction);
    } else {
      debits.add(transaction);
    }
  }

  return {'credits': credits, 'debits': debits};
}
