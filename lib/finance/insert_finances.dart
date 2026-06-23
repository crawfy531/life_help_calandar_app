
import 'package:life_help_calandar_project/data/user_database.dart';
import 'package:sqflite/sqlite_api.dart';

// id INTEGER PRIMARY KEY AUTOINCREMENT,
// finance_category TEXT,
// datetime TEXT,
// finance_amount INTEGER,
// finance_note TEXT

void prep_financial_data(int? id, String finance_category, DateTime date_time, String finance_amount, bool expense, String finance_note){
  int negativity = 1;
  if(expense == true){
    negativity = -1;
  }
  int int_finance_amount = int.parse(finance_amount) ?? 0;
  int finance_amount_negativity = int_finance_amount * negativity;
  String text_time = date_time.toIso8601String();

  if (id == null)
  {
    insert_financial_data(
        datetime: text_time, finance_category: finance_category, finance_note: finance_note, finance_amount: finance_amount_negativity);
  }
  else{updatefinancesEntry(
      id: id, datetime: text_time, finance_category: finance_category, finance_note: finance_note, finance_amount: finance_amount_negativity);


  }


}

Future<void> insert_financial_data({
  required String datetime,
  required String finance_category,
  required int finance_amount,
  required String finance_note
})
async{
  final db = await DatabaseHelper().database;
  await db.insert('finances', {
    'finance_category': finance_category,
    'datetime': datetime,
    'finance_note': finance_note,
    'finance_amount': finance_amount,
  });
}

Future<void> updatefinancesEntry({
  required int id,
  required String datetime,
  required String finance_category,
  required int finance_amount,
  required String finance_note
}) async {
  final db = await DatabaseHelper().database;

  // Only update non-null fields
  final updateData = <String, Object?>{};
  if (finance_category != null) updateData['finance_category'] = finance_category;
  if (datetime != null) updateData['datetime'] = datetime;
  if (finance_note != null) updateData['finance_note'] = finance_note;
  if (finance_amount != null) updateData['finance_amount'] = finance_amount;

  await db.update(
    'finances',
    updateData,
    where: 'id = ?',
    whereArgs: [id],
  );
}
