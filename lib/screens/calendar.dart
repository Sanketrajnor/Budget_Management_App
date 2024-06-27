import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
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

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  Map<String, dynamic> dailySummary = {
    'balance': 0.0,
    'credits': 0.0,
    'debits': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    fetchTransactions(_focusedDay); // Fetch transactions for the current day on initialization
  }

  Future<void> fetchTransactions(DateTime selectedDay) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Calculate start and end timestamps for the selected day
    DateTime startOfDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 0, 0, 0);
    DateTime endOfDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 23, 59, 59);

    // Fetch transactions within the selected day range
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay.millisecondsSinceEpoch)
        .where('timestamp', isLessThanOrEqualTo: endOfDay.millisecondsSinceEpoch)
        .get();

    double totalCredits = 0.0;
    double totalDebits = 0.0;

    // Calculate total credits and debits for the selected day
    snapshot.docs.forEach((doc) {
      Transaction transaction = Transaction.fromFirestore(doc);
      if (transaction.isCredit) {
        totalCredits += transaction.amount;
      } else {
        totalDebits += transaction.amount;
      }
    });

    // Calculate total balance
    double totalBalance = totalCredits - totalDebits;

    // Update state with fetched data
    setState(() {
      dailySummary = {
        'balance': totalBalance,
        'credits': totalCredits,
        'debits': totalDebits,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 194, 28, 78),
        title: Text(
          "Financial Calendar",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) async {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              // Fetch transactions for the selected day
              await fetchTransactions(selectedDay);
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
          ),
          SizedBox(height: 20),
          if (_selectedDay != null || dailySummary['balance'] != 0.0) ...[
            Text(
              'Summary for Selected Day:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildTransactionItem('Total Balance', dailySummary['balance'], Colors.blue),
            _buildTransactionItem('Total Credits', dailySummary['credits'], Colors.green),
            _buildTransactionItem('Total Debits', dailySummary['debits'], Colors.red),
          ],
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String label, double amount, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(
            '\₹ ${amount.toStringAsFixed(0)}',
            style: TextStyle(fontSize: 18, color: textColor),
          ),
        ],
      ),
    );
  }
}
