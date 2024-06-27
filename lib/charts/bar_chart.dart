import 'package:budget_tracker/services/trans_anal_serv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample extends StatelessWidget {
  final List<TransactionAnal> transactions;

  BarChartSample({required this.transactions});

  @override
  Widget build(BuildContext context) {
    Map<DateTime, Map<String, double>> dailyTotals = {};

    // Organize transactions by day and category (credit/debit)
    for (var transaction in transactions) {
      DateTime date = DateTime(transaction.date.year, transaction.date.month, transaction.date.day);
      if (!dailyTotals.containsKey(date)) {
        dailyTotals[date] = {'credit': 0.0, 'debit': 0.0};
      }
      if (transaction.isCredit) {
        dailyTotals[date]!['credit'] = dailyTotals[date]!['credit']! + transaction.amount;
      } else {
        dailyTotals[date]!['debit'] = dailyTotals[date]!['debit']! + transaction.amount;
      }
    }

    List<BarChartGroupData> barGroups = [];
    int index = 0;
    dailyTotals.forEach((date, totals) {
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: totals['credit']!,
              color: Colors.green,
              width: 15,
              borderRadius: BorderRadius.circular(4),
              rodStackItems: [
                BarChartRodStackItem(
                  0,
                  totals['credit']!,
                  Colors.green,
                ),
              ],
            ),
            BarChartRodData(
              toY: totals['debit']!,
              color: Colors.red,
              width: 15,
              borderRadius: BorderRadius.circular(4),
              rodStackItems: [
                BarChartRodStackItem(
                  0,
                  totals['debit']!,
                  Colors.red,
                ),
              ],
            ),
          ],
          showingTooltipIndicators: [0, 1],
        ),
      );
      index++;
    });

    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 10),
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final date = dailyTotals.keys.elementAt(value.toInt());
                  return Text(
                    '${date.day}/${date.month}',
                    style: TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipPadding: const EdgeInsets.only(top: 0,left: 10,bottom: 0), // Adjust padding
              tooltipMargin: 4, // Adjust margin
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String type = rod.color == Colors.green ? 'Credit' : 'Debit';
                double value = rod.toY;
                return BarTooltipItem(
                  '$type\n',
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 8,
                  ),
                  children: [
                    TextSpan(
                      text: '₹${value.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 8,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
