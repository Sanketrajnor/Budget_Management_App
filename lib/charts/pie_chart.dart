import 'package:budget_tracker/services/trans_anal_serv.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:budget_tracker/services/colors.dart';

class PieChartWidget extends StatefulWidget {
  final List<TransactionAnal> transactions;

  PieChartWidget(this.transactions);

  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {};
    widget.transactions.forEach((transaction) {
      if (dataMap.containsKey(transaction.category)) {
        dataMap[transaction.category] =
            dataMap[transaction.category]! + transaction.amount;
      } else {
        dataMap[transaction.category] = transaction.amount;
      }
    });

    List<PieChartSectionData> sections = dataMap.entries.map((entry) {
      final color = categoryColors[entry.key] ?? Colors.grey; // Default color if category not found
      return PieChartSectionData(
        value: entry.value,
        title: '',
        color: color,
        radius: 100,
        badgeWidget: touchedIndex == dataMap.keys.toList().indexOf(entry.key)
            ? _Badge(
                text: '${entry.key}: ₹${entry.value.toStringAsFixed(0)}',
                color: color,
              )
            : null,
        badgePositionPercentageOffset: 1.2,
      );
    }).toList();

    return Row(
      children: [
        Expanded(
          flex: 4, // Adjust flex value as needed
          child: Stack(
            children: [
              Center(
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: 15,
                    sectionsSpace: 0,
                    borderData: FlBorderData(show: false),
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (pieTouchResponse != null &&
                              pieTouchResponse.touchedSection != null) {
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          } else {
                            touchedIndex = -1;
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2, // Adjust flex value as needed
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20), // Adjust spacing as needed
                Expanded(
                  child: ListView(
                    children: dataMap.entries.map((entry) {
                      final color =
                          categoryColors[entry.key] ?? Colors.grey;
                      return Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        color: touchedIndex ==
                                dataMap.keys.toList().indexOf(entry.key)
                            ? Colors.grey.withOpacity(0.3)
                            : Colors.transparent,
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: touchedIndex ==
                                        dataMap.keys.toList().indexOf(entry.key)
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 2),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
