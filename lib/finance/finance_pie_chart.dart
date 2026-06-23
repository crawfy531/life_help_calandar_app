import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:life_help_calandar_project/data/user_database.dart';

class FinanceCategoryPieChart extends StatefulWidget {
  const FinanceCategoryPieChart({super.key});

  @override
  _FinanceCategoryPieChartState createState() => _FinanceCategoryPieChartState();
}

class _FinanceCategoryPieChartState extends State<FinanceCategoryPieChart> {
  Map<String, int> _categoryTotals = {};

  @override
  void initState() {
    super.initState();
    _loadCategoryData();
  }

  Future<void> _loadCategoryData() async {
    final db = await DatabaseHelper().database;
    final results = await db.query('finances');

    final Map<String, int> categoryTotals = {};
    for (var row in results) {
      final category = (row['finance_category'] ?? 'Unknown').toString();
      final amount = int.tryParse(row['finance_amount'].toString()) ?? 0;
      categoryTotals.update(category, (val) => val + amount, ifAbsent: () => amount);
    }

    // Sort and limit to top 10 by absolute value
    final sortedEntries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.abs().compareTo(a.value.abs()));
    final limited = Map.fromEntries(sortedEntries.take(10));

    setState(() {
      _categoryTotals = limited;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_categoryTotals.isEmpty) {
      return const Center(child: Text("No finance data available."));
    }

    final total = _categoryTotals.values.fold(0, (a, b) => a + b).abs();

    return Row(
      children: [
        SizedBox(
          width: 200,
          height: 250,
          child: PieChart(
            PieChartData(
              sections: _categoryTotals.entries.map((entry) {
                final value = entry.value.toDouble();
                final color = value >= 0 ? Colors.green : Colors.red;

                return PieChartSectionData(
                  value: value.abs(),
                  radius: 60,
                  color: color,
                  showTitle: false,
                );
              }).toList(),
              centerSpaceRadius: 30,
              sectionsSpace: 2,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _categoryTotals.entries.map((entry) {
                final color = entry.value >= 0 ? Colors.green : Colors.red;
                final percent = (entry.value.abs() / total * 100).toStringAsFixed(1);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Container(width: 12, height: 12, color: color),
                      const SizedBox(width: 6),
                      Expanded(child: Text(entry.key, overflow: TextOverflow.ellipsis)),
                      Text('$percent%'),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
