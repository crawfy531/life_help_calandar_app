



// Custom Widgets
// Data


// Health - Mental Health



import 'package:life_help_calandar_project/data/user_database.dart';
import 'package:sqflite/sqlite_api.dart';

Future<void>prep_goal_data(
    int? id,
    String category,
    String title,
    DateTime start_date,
    DateTime end_date,
    DateTime time,
    // bool sun, bool mon, bool tue, bool wed, bool thu, bool fri, bool sat,
    String frequency_amount,
    String frequency_time,
    String goal_content,
    bool goal_complete
    ) async{

    String time_string = time.toIso8601String();
    String start_date_string = start_date.toIso8601String();
    String end_date_string = end_date.toIso8601String();
    int int_frequency_amount = int.parse(frequency_amount);

    int complete = 1;
    if(goal_complete == false){
      complete = 0;
    }




  if (id == null)
  {
    await insert_goal_data(
        category: category,
        title: title,
        start_date: start_date_string,
        time_of_day: time_string,
        end_date: end_date_string,
        frequency_amount: int_frequency_amount,
        frequency_time: frequency_time,
        goal_content: goal_content,
        goal_complete: complete
    );
  }
  else{
    await updateGoalEntry(
      id: id,
        category: category,
        title: title,
        start_date: start_date_string,
        time_of_day: time_string,
        end_date: end_date_string,
        frequency_amount: int_frequency_amount,
        frequency_time: frequency_time,
        goal_content: goal_content,
        goal_complete: complete
    );

  }


}


// CREATE TABLE goals(
// id INTEGER PRIMARY KEY AUTOINCREMENT,
// category TEXT,
// title Text,
// start_date TEXT,
// time_of_day TEXT,
// end_date TEXT,
// frequency_amount INTEGER,
// frequency_time TEXT,
// goal_content TEXT,
// goal_complete INTEGER,
// parent_id INTEGER,
// FOREIGN KEY (parent_id) REFERENCES goals(id) ON DELETE CASCADE)

Future<void> insert_goal_data({
  required String category,
  required String title,
  required String start_date,
  required String time_of_day,
  required String end_date,
  required int frequency_amount,
  required String frequency_time,
  required String goal_content,
  required int goal_complete,
})
async{
  final db = await DatabaseHelper().database;
  await db.insert('goals', {
    'category': category,
    'title': title,
    'start_date': start_date,
    'time_of_day': time_of_day,
    'end_date': end_date,
    'frequency_amount': frequency_amount,
    'frequency_time': frequency_time,
    'goal_content': goal_content,
    'goal_complete': goal_complete,
    'parent_id': null,
  });
  final response = await db.query("goals");
  for (final row in response) {
    print(row);
  }
}

Future<void> updateGoalEntry({
  required id,
  required String category,
  required String title,
  required String start_date,
  required String time_of_day,
  required String end_date,
  required int frequency_amount,
  required String frequency_time,
  required String goal_content,
  required int goal_complete,
}) async {
  final db = await DatabaseHelper().database;

  // Only update non-null fields
  final updateData = <String, Object?>{};
  if (category != null) updateData['category'] = category;
  if (title != null) updateData['title'] = title;
  if (start_date != null) updateData['start_date'] = start_date;
  if (time_of_day != null) updateData['time_of_day'] = time_of_day;
  if (end_date != null) updateData['end_date'] = end_date;
  if (frequency_amount != null) updateData['frequency_amount'] = frequency_amount;
  if (frequency_time != null) updateData['frequency_time'] = frequency_time;
  if (goal_content != null) updateData['goal_content'] = goal_content;
  if (goal_complete != null) updateData['goal_complete'] = goal_complete;

  await db.update(
    'goals',
    updateData,
    where: 'id = ?',
    whereArgs: [id],
  );

  final response = await db.query("goals");
  for (final row in response) {
    print(row);
  }
}
