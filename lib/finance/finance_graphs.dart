import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:life_help_calandar_project/data/user_database.dart';
import 'package:intl/intl.dart';

class FinanceLineChart extends StatefulWidget {
  const FinanceLineChart({super.key});

  @override
  State<FinanceLineChart> createState() => _FinanceLineChartState();
}

class _FinanceLineChartState extends State<FinanceLineChart> {
  Map<String, int> _accumulatedFinance = {};

  @override
  void initState() {
    super.initState();
    _loadFinanceData();
  }

  Future<void> _loadFinanceData() async {
    final db = await DatabaseHelper().database;
    final results = await db.query('finances');

    final Map<String, int> dailyChanges = {};
    for (var row in results) {
      final dateStr = row['datetime'].toString();
      final date = DateTime.tryParse(dateStr);
      if (date == null) continue;

      final key = DateFormat('yyyy-MM-dd').format(date);
      final amount = int.tryParse(row['finance_amount'].toString()) ?? 0;
      dailyChanges.update(key, (value) => value + amount, ifAbsent: () => amount);
    }

    int runningTotal = 0;
    final accumulated = <String, int>{};
    final sortedEntries = dailyChanges.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    for (var entry in sortedEntries) {
      runningTotal += entry.value;
      accumulated[entry.key] = runningTotal;
    }

    setState(() {
      _accumulatedFinance = accumulated;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_accumulatedFinance.isEmpty) return const Text("No finance data available.");

    final keys = _accumulatedFinance.keys.toList();
    final spots = <FlSpot>[];
    for (int i = 0; i < keys.length; i++) {
      final dateStr = keys[i];
      final value = _accumulatedFinance[dateStr]!.toDouble();
      spots.add(FlSpot(i.toDouble(), value));
    }

    final maxY = (_accumulatedFinance.values.reduce((a, b) => a > b ? a : b) * 1.2).ceilToDouble();
    final minY = (_accumulatedFinance.values.reduce((a, b) => a < b ? a : b) * 1.2).floorToDouble();
    final interval = (maxY - minY) / 5;

    return AspectRatio(
      aspectRatio: 1.6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            minY: minY,
            maxY: maxY,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: interval,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Text(value.toInt().toString(), style: const TextStyle(fontSize: 10)),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < keys.length && (index == 0 || index % 2 == 0)) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(DateFormat.Md().format(DateTime.parse(keys[index])), style: const TextStyle(fontSize: 10)),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(show: true),
            borderData: FlBorderData(
              show: true,
              border: const Border(
                left: BorderSide(),
                bottom: BorderSide(),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Colors.blue,
                barWidth: 2,
                belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
                dotData: FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
