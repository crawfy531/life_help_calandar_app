

import 'package:life_help_calandar_project/data/user_database.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:convert'; // at the top



void prep_nutrition_data(
int? id,
DateTime date,
String serving_amount,
String food,
String food_category,
List<String>? ingredients,
String serving_size,
String serving_size_unit,
String? serving_description,
List nutrients,

)
// await db.execute(
// '''CREATE TABLE nutrition(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         date TEXT,
//         serving_number INTEGER,
//         food TEXT,
//         food_category TEXT,
//         ingredients TEXT,
//         serving_size INTEGER,
//         serving_unit TEXT,
//         serving_description TEXT,
//         nutrients TEXT)'''
// );
{
String string_date = date.toIso8601String();
int amount = int.parse(serving_amount);
String? ingredients_string = ingredients.toString();
int serving_int = int.parse(serving_size);
String nutrients_string = jsonEncode(
  nutrients.map((n) => {
    'nutrientName': n.name,
    'value': n.value,
    'unit': n.unit,
  }).toList(),
);

if(id == null){
  insert_nutrition_data(
      date: string_date,
      serving_number: amount,
      food: food,
      food_category: food_category,
      ingredients: ingredients_string,
      serving_size: serving_int,
      serving_unit: serving_size_unit,
      serving_description: serving_description,
      nutrients: nutrients_string);
}
else{
  updateNutrientEntry(
      id : id,
      date: string_date,
      serving_number: amount,
      food: food,
      food_category: food_category,
      ingredients: ingredients_string,
      serving_size: serving_int,
      serving_unit: serving_size_unit,
      serving_description: serving_description,
      nutrients: nutrients_string);
}

}

Future<void> insert_nutrition_data({
  required String date,
  required int serving_number,
  required String food,
  required String food_category,
  required String? ingredients,
  required int serving_size,
  required String serving_unit,
  required String? serving_description,
  required String nutrients,
})
async{
  final db = await DatabaseHelper().database;
  await db.insert('nutrition', {
    'date': date,
    'serving_number': serving_number,
    'food_category': food_category,
    'food': food,
    'ingredients': ingredients,
    'serving_size': serving_size,
    'serving_unit': serving_unit,
    'serving_description': serving_description,
    'nutrients': nutrients,
  });

  final response = await db.query("nutrition");
  for (final row in response) {
    print(row);
  }
}

Future<void> updateNutrientEntry({
  required int id,
  required String date,
  required int serving_number,
  required String food,
  required String food_category,
  required String? ingredients,
  required int serving_size,
  required String serving_unit,
  required String? serving_description,
  required String nutrients,
}) async {
  final db = await DatabaseHelper().database;

  final updateData = <String, Object?>{};
  if (serving_number != null) updateData['serving_number'] = serving_number;
  if (food != null) updateData['food'] = food;
  if (food_category != null) updateData['food_category'] = food_category;
  if (ingredients != null) updateData['ingredients'] = ingredients;
  if (serving_size != null) updateData['serving_size'] = serving_size;
  if (serving_unit != null) updateData['serving_unit'] = serving_unit;
  if (serving_description != null) updateData['serving_description'] = serving_description;
  if (nutrients != null) updateData['nutrients'] = nutrients;


  await db.update(
    'nutrition',
    updateData,
    where: 'id = ?',
    whereArgs: [id],
  );

  final response = await db.query("nutrition");
  for (final row in response) {
    print(row);
  }
}
