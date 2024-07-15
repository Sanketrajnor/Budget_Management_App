import 'package:flutter/material.dart';
import 'package:budget_tracker/charts/pie_chart.dart';
import 'package:budget_tracker/charts/line_chart.dart';  
import 'package:budget_tracker/services/trans_anal_serv.dart';

class AnalysisScreen extends StatefulWidget {
  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  Map<String, List<TransactionAnal>>? transactions;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchTransactionsAnal().then((data) {
      setState(() {
        transactions = data;
      });
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 194, 28, 78),
        title: Text(
          "Transactional Analysis",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: transactions == null
          ? Center(child: CircularProgressIndicator())
          : Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      "Monthwise Credit & Debit 2024",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 300, // Define a fixed height for the line chart
                      child: LineChartSample(
                        transactions: transactions!['credits']!.followedBy(transactions!['debits']!).toList(),
                      ),
                    ),

                    Container(
                      color: Colors.white,
                      child: TabBar(
                        controller: _tabController,
                        labelColor: Colors.pink,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.pink,
                        tabs: [
                          Tab(text: "Credit"),
                          Tab(text: "Debit"),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      "Category Wise Credits & Debits",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 300,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          PieChartWidget(transactions!['credits'] ?? []),
                          PieChartWidget(transactions!['debits'] ?? []),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
