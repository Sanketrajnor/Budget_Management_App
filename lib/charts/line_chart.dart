import 'package:budget_tracker/services/trans_anal_serv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample extends StatelessWidget {
  final List<TransactionAnal> transactions;

  LineChartSample({required this.transactions});

  List<String> getMonthShortNames() {
    return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  }

  @override
  Widget build(BuildContext context) {
    Map<int, Map<String, double>> monthlyTotals = {};

    // Organize transactions by month and category (credit/debit)
    for (var transaction in transactions) {
      int month = transaction.date.month;
      if (!monthlyTotals.containsKey(month)) {
        monthlyTotals[month] = {'credit': 0.0, 'debit': 0.0};
      }
      if (transaction.isCredit) {
        monthlyTotals[month]!['credit'] = monthlyTotals[month]!['credit']! + transaction.amount;
      } else {
        monthlyTotals[month]!['debit'] = monthlyTotals[month]!['debit']! + transaction.amount;
      }
    }

    List<FlSpot> creditSpots = [];
    List<FlSpot> debitSpots = [];
    for (int month = 1; month <= 12; month++) {
      double credit = monthlyTotals[month]?['credit'] ?? 0.0;
      double debit = monthlyTotals[month]?['debit'] ?? 0.0;
      creditSpots.add(FlSpot(month.toDouble(), credit));
      debitSpots.add(FlSpot(month.toDouble(), debit));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: creditSpots,
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: false),
                    dotData: FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: debitSpots,
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: false),
                    dotData: FlDotData(show: false),
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '₹${value.toInt()}',
                          style: TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int monthIndex = value.toInt() - 1;
                        if (monthIndex >= 0 && monthIndex < 12) {
                          return Text(
                            getMonthShortNames()[monthIndex],
                            style: TextStyle(fontSize: 10),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                gridData: FlGridData(show: true),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Indicator(color: Colors.green, text: 'Total Monthly Credit'),
              SizedBox(width: 20),
              Indicator(color: Colors.red, text: 'Total Monthly Debit'),
            ],
          ),
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;

  Indicator({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          color: color,
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
