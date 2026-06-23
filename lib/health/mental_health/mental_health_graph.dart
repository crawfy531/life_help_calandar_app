import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:life_help_calandar_project/data/user_database.dart';
import 'package:intl/intl.dart';

class MentalHealthLineChart extends StatefulWidget {
  const MentalHealthLineChart({super.key});

  @override
  State<MentalHealthLineChart> createState() => _MentalHealthLineChartState();
}

class _MentalHealthLineChartState extends State<MentalHealthLineChart> {
  Map<DateTime, int> _emotionData = {}; // Key: date, Value: emotion rank

  @override
  void initState() {
    super.initState();
    _loadEmotionData();
  }

  Future<void> _loadEmotionData() async {
    final db = await DatabaseHelper().database;
    final results = await db.query('emotion');

    final Map<DateTime, int> emotionData = {};
    for (var row in results) {
      final dateStr = row['datetime'].toString();
      final date = DateTime.tryParse(dateStr);
      if (date == null) continue;

      final normalizedDate = DateTime(date.year, date.month, date.day);
      final rank = int.tryParse(row['emotion_rank'].toString()) ?? 0;
      emotionData[normalizedDate] = rank; // Assuming one entry per day
    }

    setState(() {
      _emotionData = Map.fromEntries(emotionData.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_emotionData.isEmpty) return const Text("No mental health data available.");

    final sortedDates = _emotionData.keys.toList();
    final spots = <FlSpot>[];
    for (int i = 0; i < sortedDates.length; i++) {
      final date = sortedDates[i];
      final rank = _emotionData[date]!.toDouble();
      spots.add(FlSpot(i.toDouble(), rank));
    }

    final interval = 1.0;

    return AspectRatio(
      aspectRatio: 1.6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: sortedDates.length.toDouble() - 1,
            minY: 0,
            maxY: 10,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: interval,
                  getTitlesWidget: (value, meta) => Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Text(value.toInt().toString(), style: const TextStyle(fontSize: 10)),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < sortedDates.length && index % 2 == 0) {
                      final date = sortedDates[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(DateFormat.Md().format(date), style: const TextStyle(fontSize: 10)),
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
                color: Colors.purple,
                barWidth: 2,
                belowBarData: BarAreaData(show: true, color: Colors.purple.withOpacity(0.2)),
                dotData: FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
