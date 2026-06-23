import 'package:life_help_calandar_project/data/user_database.dart';


Future<List<Map<String, dynamic>>> getEmotionsForDate(DateTime date) async {
  final db = await DatabaseHelper().database;
  final start = DateTime(date.year, date.month, date.day);
  final end = start.add(Duration(days: 1));

  return await db.query(
    'emotion',
    where: 'datetime >= ? AND datetime < ?',
    whereArgs: [start.toIso8601String(), end.toIso8601String()],
  );
}



Future<List<Map<String, dynamic>>> getGoalsBetweenDates(DateTime start, DateTime end) async {
  final db = await DatabaseHelper().database;
  return await db.query(
    'goals',
    where: 'start_date <= ? AND end_date >= ?',
    whereArgs: [end.toIso8601String(), start.toIso8601String()],
  );
}

List<DateTime> getGoalOccurrences({
  required DateTime startDate,
  required DateTime endDate,
  required int frequencyAmount,
  required String frequencyTime,
}) {
  List<DateTime> occurrences = [];
  DateTime current = startDate;

  while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
    occurrences.add(current);

    switch (frequencyTime.toLowerCase()) {
      case 'day':
        current = current.add(Duration(days: frequencyAmount));
        break;
      case 'week':
        current = current.add(Duration(days: 7 * frequencyAmount));
        break;
      case 'month':
        current = DateTime(current.year, current.month + frequencyAmount, current.day);
        break;
      case 'year':
        current = DateTime(current.year + frequencyAmount, current.month, current.day);
        break;
      default:
        throw Exception('Unknown frequency time: $frequencyTime');
    }
  }

  return occurrences;
}


Future<List<Map<String, dynamic>>> getNutritionEntriesForDate(DateTime date) async {
  final db = await DatabaseHelper().database;
  final start = DateTime(date.year, date.month, date.day);
  final end = start.add(Duration(days: 1));

  return await db.query(
    'nutrition',
    where: 'date >= ? AND date < ?',
    whereArgs: [start.toIso8601String(), end.toIso8601String()],
  );
}





Future<List<Map<String, dynamic>>> getFinancesForDate(DateTime date) async {
  final db = await DatabaseHelper().database;
  final start = DateTime(date.year, date.month, date.day);
  final end = start.add(Duration(days: 1));

  return await db.query(
    'finances',
    where: 'datetime >= ? AND datetime < ?',
    whereArgs: [start.toIso8601String(), end.toIso8601String()],
  );
}
