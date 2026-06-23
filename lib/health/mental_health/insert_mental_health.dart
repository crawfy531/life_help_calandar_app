



// Custom Widgets
// Data


// Health - Mental Health


// id INTEGER PRIMARY KEY AUTOINCREMENT,
// datetime TEXT,
// emotion_name TEXT,
// emotion_description TEXT,
// emotion_icon TEXT,
// emotion_rank INTEGER

import 'package:life_help_calandar_project/data/user_database.dart';
import 'package:sqflite/sqlite_api.dart';

  Future<void> prep_mental_health_data(int? id, String emotionIcon, int emotionRank, String emotionDescription, String emotionName, DateTime date, DateTime time) async {

  DateTime full_time = DateTime(date.year,date.month,date.day,time.hour,time.minute);
  String text_time = full_time.toIso8601String();

  if (id == null)
  {
    await insert_mental_health_data(
        datetime: text_time,
        emotionName: emotionName,
        emotionDescription: emotionDescription,
        emotionIcon: emotionIcon,
        emotionRank: emotionRank);
  }
  else{
    await updateEmotionEntry(
      id: id,
      datetime: text_time,
      emotionName: emotionName,
      emotionDescription: emotionDescription,
      emotionIcon: emotionIcon,
      emotionRank: emotionRank);

  }


}

Future<void> insert_mental_health_data({
  required String datetime,
  required String emotionName,
  required String emotionDescription,
  required String emotionIcon,
  required int emotionRank,})
    async{
    final db = await DatabaseHelper().database;
    await db.insert('emotion', {
      'datetime': datetime,
      'emotion_name': emotionName,
      'emotion_description': emotionDescription,
      'emotion_icon': emotionIcon,
      'emotion_rank': emotionRank,
    });

    final response = await db.query("emotion");
    for (final row in response) {
      print(row);
    }
    }

Future<void> updateEmotionEntry({
  required
  int id,
  String? emotionName,
  String? emotionDescription,
  String? emotionIcon,
  int? emotionRank,
  String? datetime,
}) async {
  final db = await DatabaseHelper().database;

  // Only update non-null fields
  final updateData = <String, Object?>{};
  if (emotionName != null) updateData['emotion_name'] = emotionName;
  if (emotionDescription != null) updateData['emotion_description'] = emotionDescription;
  if (emotionIcon != null) updateData['emotion_icon'] = emotionIcon;
  if (emotionRank != null) updateData['emotion_rank'] = emotionRank;
  if (datetime != null) updateData['datetime'] = datetime;

  await db.update(
    'emotion',
    updateData,
    where: 'id = ?',
    whereArgs: [id],
  );

  final response = await db.query("emotion");
  for (final row in response) {
    print(row);
  }
}
